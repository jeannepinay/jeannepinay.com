import Foundation
import AVFoundation
import ImageIO
import CoreVideo

let args = CommandLine.arguments
let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: args[1]) as CFURL, nil)!
let out = URL(fileURLWithPath: args[2])
let maxW = Int(args.count > 3 ? args[3] : "960")!
let rate = Int(args.count > 4 ? args[4] : "900000")!
try? FileManager.default.removeItem(at: out)

let n = CGImageSourceGetCount(src)
let first = CGImageSourceCreateImageAtIndex(src, 0, nil)!
var w = first.width, h = first.height
if w > maxW { h = h * maxW / w; w = maxW }
w -= w % 2; h -= h % 2

func delay(_ i: Int) -> Double {
  let p = CGImageSourceCopyPropertiesAtIndex(src, i, nil) as? [String: Any]
  let g = p?[kCGImagePropertyGIFDictionary as String] as? [String: Any]
  let d = (g?[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double) ?? (g?[kCGImagePropertyGIFDelayTime as String] as? Double) ?? 0.1
  return d < 0.02 ? 0.1 : d
}

let writer = try AVAssetWriter(outputURL: out, fileType: .mp4)
let settings: [String: Any] = [
  AVVideoCodecKey: AVVideoCodecType.h264, AVVideoWidthKey: w, AVVideoHeightKey: h,
  AVVideoCompressionPropertiesKey: [AVVideoAverageBitRateKey: rate, AVVideoMaxKeyFrameIntervalDurationKey: 10, AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel]
]
let input = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
input.expectsMediaDataInRealTime = false
let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: [
  kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB, kCVPixelBufferWidthKey as String: w, kCVPixelBufferHeightKey as String: h])
writer.add(input)
writer.startWriting()
writer.startSession(atSourceTime: .zero)

var t = 0.0
func frame(_ img: CGImage) -> CVPixelBuffer {
  var pb: CVPixelBuffer?
  CVPixelBufferPoolCreatePixelBuffer(nil, adaptor.pixelBufferPool!, &pb)
  CVPixelBufferLockBaseAddress(pb!, [])
  let ctx = CGContext(data: CVPixelBufferGetBaseAddress(pb!), width: w, height: h, bitsPerComponent: 8,
    bytesPerRow: CVPixelBufferGetBytesPerRow(pb!), space: CGColorSpaceCreateDeviceRGB(),
    bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)!
  ctx.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
  ctx.fill(CGRect(x: 0, y: 0, width: w, height: h))
  ctx.interpolationQuality = .high
  ctx.draw(img, in: CGRect(x: 0, y: 0, width: w, height: h))
  CVPixelBufferUnlockBaseAddress(pb!, [])
  return pb!
}
var last: CGImage = first
for i in 0..<n {
  let img = CGImageSourceCreateImageAtIndex(src, i, nil)!
  last = img
  while !input.isReadyForMoreMediaData { usleep(1000) }
  adaptor.append(frame(img), withPresentationTime: CMTime(seconds: t, preferredTimescale: 600))
  t += delay(i)
}
// repeat last frame so its delay is respected
while !input.isReadyForMoreMediaData { usleep(1000) }
adaptor.append(frame(last), withPresentationTime: CMTime(seconds: t - 0.001, preferredTimescale: 600))
input.markAsFinished()
let sem = DispatchSemaphore(value: 0)
writer.finishWriting { sem.signal() }
sem.wait()
print("\(args[1].split(separator: "/").last!): \(n) frames, \(String(format: "%.1f", t))s, \(w)x\(h), status \(writer.status.rawValue)")

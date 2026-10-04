# jeannepinay.com

Single-page static academic website, served by GitHub Pages from the `main` branch root, at https://jeannepinay.com (custom domain set in `CNAME`). No build step, no framework: edit `index.html` and `style.css` directly.

## Structure of index.html
- Top bar: name and menu (Research, Publications, Teaching, CV). Publications is hidden on phones. The CV link lives only in this menu.
- Banner: plain old world map (no text on it, the owner prefers it that way): Rumold Mercator, Orbis Terrae Compendiosa Descriptio, 1587 (Latin, public domain). The image is the Wikimedia Commons copy "Rumold Mercator, Orbis terrae compendiosa descriptio (FL27969723 2718451).jpg" (purple ornaments, sepia tones), cropped as a wide band across both hemispheres down to the equator. Do not swap it for a different map; the owner wants this one, ideally in higher resolution with a wide view that always includes Europe. Then the Marc Bloch quote with its English translation (`.quote-translation`).
- About: portrait on the left, always exactly as tall as the biography block (the text sets the height; the photo is cropped with object-fit: cover; on phones it stacks at natural size); biography on the right, ending with a `.contact` row (LinkedIn and Google Scholar icons, email).
- `<section id="research">` with `<h2 class="section-title">` and `<h3 class="sub-title">` sub-sections: Working Papers, Work in Progress, Publications (`id="publications"`).
  - Each paper is an `<article class="paper">`:
    - `<button class="paper-fig" data-full="images/NAME.gif">` holding `<video src="images/NAME-small.mp4" autoplay muted loop playsinline>`. Clicking opens the original GIF in the `#lightbox` dialog (GIF stays sharp; video looked grainy when enlarged).
    - `<div class="paper-meta">`: `<h4>` title, co-authors, status, then `<div class="paper-links">` with `.tag` buttons (Abstract, related project with an explicit label). No PDF button: the paper title is the PDF link, then `<div class="abstract" id="abstract-NAME" hidden>`.
    - The Abstract button needs `aria-controls="abstract-NAME"` matching the abstract's id; the script at the bottom of the page handles opening and closing.
  - Publications and teaching are `.entry` blocks: title, co-authors, then journal in `<strong><em>` followed by the year or "forthcoming" in the same line (the owner does not want a separate date column). "Pre-doctoral publications" is a `.entries-note` label in grey capitals. Co-authors are written "with A, B, and C" without parentheses, in alphabetical order by surname on the website (in the CV they follow the order of the publication).
- `<section id="teaching">` with the same `.entry` rows.
- Footer: "Last updated <Month Year>". Update it whenever content changes.

## Other pages and files
- `italian-elections/index.html`: page showing the Streamlit app (https://itapolitics.streamlit.app, hosted by Streamlit) in an iframe with `?embed=true`. The "Interactive maps" button of the Colonial Roots paper links here.
- `404.html`: page shown by GitHub Pages for any missing address. Subpages and 404 use absolute paths (`/style.css`).
- `home/index.html`: redirects the old Google Sites address jeannepinay.com/home to the home page.
- `fonts/`: EB Garamond and Lato served from the site (no Google Fonts requests, for visitor privacy). `fonts/fonts.css` must be linked before `style.css` on every page.
- `sitemap.xml` and `robots.txt` for search engines; update `lastmod` in the sitemap when pages change. `index.html` also has schema.org Person data (JSON-LD) in the head; keep it in sync with affiliations and profiles.

## PDFs
- The CV and working-paper PDFs live in `files/` and are linked directly (they open in the browser, no Google Drive).
  - `files/cv.pdf` is linked from the CV item in the top menu.
  - `files/colonial-roots-of-nationalism.pdf` is linked from the paper title.
- To update one, replace the file keeping the same name, so the links on the site and elsewhere keep working.
- The CV source is `files/cv.tex` (kept out of git by `.gitignore`, so only the PDF is published).
  - It uses EB Garamond and the site's navy, with `\entry{Title}{Date}{Details}` and `\paper{Title}{Details}` macros.
  - Build: copy it to a scratch folder, run `pdflatex cv.tex` twice, check it stays at 2 pages, then copy `cv.pdf` back to `files/`.
  - Update the "Last updated" footer date and keep co-authors, titles and abstracts consistent with `index.html`.

## Paper animations
- The page shows light MP4 thumbnails; the original GIFs in `images/` are used for the enlarged view.
- To convert a new GIF, compile and run the converter (needs only Xcode command line tools):
  `swiftc -O tools/gif2mp4.swift -o /tmp/gif2mp4`
  `/tmp/gif2mp4 images/NAME.gif images/NAME-small.mp4 480 140000` (thumbnail shown in the page)

## Conventions
- Fonts: EB Garamond (text), Lato (top bar, menu, buttons, labels). Colours and sizes (`--max` page width, `--fig` image width, `--when` year column) are CSS variables at the top of `style.css`.
- The owner wants to keep the original colours and fonts; layout improvements are welcome.
- Titles and info lines of papers should fit on one line on desktop; keep spacing between them tight. No separator lines between papers.
- Show changes in the local preview and publish only after the owner approves.
- Images go in `images/` with short lowercase names.
- Check the layout at phone width (375px) and at a narrow window (600px) before committing.
- Preview locally with `python3 -m http.server 8000` and open http://localhost:8000.
- When `style.css` changes, bump the `?v=` number on its `<link>` in `index.html`, `404.html` and `italian-elections/index.html` (use the current date and time), so browsers load the new version instead of a cached one.
- After changes: commit with a short message and push to `main`.

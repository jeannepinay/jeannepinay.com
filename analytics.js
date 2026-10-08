/* Google Analytics with a consent banner.
   Analytics is loaded ONLY after the visitor clicks "Accept"; nothing is sent to Google otherwise.
   The choice is remembered in this browser; the "Cookie settings" link in the footer reopens the banner. */
(function () {
  var GA_ID = 'G-DVQKSZ3JN3';            // Google Analytics measurement ID
  var KEY = 'analytics-consent';          // stored value: "granted" or "denied"

  function getChoice() { try { return localStorage.getItem(KEY); } catch (e) { return null; } }
  function setChoice(v) { try { localStorage.setItem(KEY, v); } catch (e) {} }

  function loadAnalytics() {
    if (window.__gaLoaded || GA_ID.indexOf('XXXX') !== -1) return;
    window.__gaLoaded = true;
    var s = document.createElement('script');
    s.async = true;
    s.src = 'https://www.googletagmanager.com/gtag/js?id=' + GA_ID;
    document.head.appendChild(s);
    window.dataLayer = window.dataLayer || [];
    window.gtag = function () { dataLayer.push(arguments); };
    gtag('js', new Date());
    gtag('config', GA_ID, { anonymize_ip: true });
  }

  function showBanner() {
    if (document.getElementById('consent')) return;
    var box = document.createElement('div');
    box.id = 'consent';
    box.setAttribute('role', 'dialog');
    box.setAttribute('aria-label', 'Cookie consent');
    box.innerHTML =
      '<p>This website uses Google Analytics cookies to count visits. No data is collected unless you accept.</p>' +
      '<div class="consent-buttons">' +
        '<button type="button" class="tag" data-choice="denied">Decline</button>' +
        '<button type="button" class="tag consent-accept" data-choice="granted">Accept</button>' +
      '</div>';
    box.addEventListener('click', function (e) {
      var choice = e.target.getAttribute('data-choice');
      if (!choice) return;
      setChoice(choice);
      box.remove();
      if (choice === 'granted') loadAnalytics();
    });
    document.body.appendChild(box);
  }

  function start() {
    var choice = getChoice();
    if (choice === 'granted') loadAnalytics();
    else if (choice !== 'denied') showBanner();
    document.querySelectorAll('.cookie-settings').forEach(function (a) {
      a.addEventListener('click', function (e) { e.preventDefault(); showBanner(); });
    });
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', start);
  else start();
})();

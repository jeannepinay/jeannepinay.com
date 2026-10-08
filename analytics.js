/* Google Analytics (GA4), loaded on every page view. No consent banner (owner's choice). */
(function () {
  var GA_ID = 'G-DVQKSZ3JN3';            // Google Analytics measurement ID
  var s = document.createElement('script');
  s.async = true;
  s.src = 'https://www.googletagmanager.com/gtag/js?id=' + GA_ID;
  document.head.appendChild(s);
  window.dataLayer = window.dataLayer || [];
  window.gtag = function () { dataLayer.push(arguments); };
  gtag('js', new Date());
  gtag('config', GA_ID, { anonymize_ip: true });
  try { localStorage.removeItem('analytics-consent'); } catch (e) {}   // leftover from the old banner
})();

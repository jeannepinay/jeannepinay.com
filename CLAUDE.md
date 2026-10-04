# jeannepinay.com

Single-page static academic website, served by GitHub Pages from the `main` branch root. No build step, no framework: edit `index.html` and `style.css` directly.

## Structure of index.html
- About: portrait, LinkedIn and Google Scholar icons, CV button (Google Drive link), email, biography.
- RESEARCH band, then grey sub-bands: Working Papers, Work in Progress, Publications.
  - Each paper is an `<article class="paper">` with an image, an `<h4>` title, co-authors, status, and the abstract inside `<details>`.
  - Each publication is a `<div class="pub">`: `<h4>` title (linked), co-authors, journal in `<strong><em>`.
- TEACHING band with `<div class="pub">` entries.
- Footer: "Last updated <Month Year>". Update it whenever content changes.

## Conventions
- Fonts: EB Garamond (text), Lato (top bar, CV button, labels). Colours are CSS variables at the top of `style.css`.
- Images go in `images/` with short lowercase names.
- Check the layout at phone width before committing.
- Preview locally with `python3 -m http.server 8000` and open http://localhost:8000.
- After changes: commit with a short message and push to `main`.

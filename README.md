# CV Generator (Typst)

Sleek, single-page CV template — blue accents, Inter typeface. Content lives
entirely in `data.json`; `main.typ` never needs to change for a text update.

## Build

```powershell
.\build.ps1
```

Or directly:

```powershell
typst compile --font-path fonts --input "data=data.json" main.typ cv.pdf
```

Use `--input "data=other.json"` (or `.\build.ps1 -Data other.json -Out other.pdf`)
to render a different profile without touching the template.

## Languages

The template itself is language-agnostic — every visible string comes from the
data file. Two profiles ship with the repo:

```powershell
.\build.ps1            # data.json    -> cv.pdf     (French)
.\build.ps1 -Lang en   # data.en.json -> cv.en.pdf  (English)
```

To add another language, copy `data.json`, translate the content, and set:

- `lang`: a two-letter code (`"fr"`, `"en"`, …) — drives Typst's hyphenation
  and smart-quote rules. Defaults to `"fr"`.
- `labels`: overrides for the section headings. Any key you omit falls back to
  its French default, so a French CV needs no `labels` block at all. Keys:
  `languages`, `strengths`, `skills`, `interests`, `certifications`,
  `first_aid`, `experience`, `education`, `activities`.

## Editing content

Edit `data.json`. Every top-level key is optional — remove a section (e.g.
`"certifications"`) and it simply won't render. Fields:

- `name`, `title`, `tagline`, `photo` (path to a square-ish image, circle-cropped)
- `social`: `[{label, value}]` — top-right links (GitHub, LinkedIn, …)
- `quick_info`: `[{icon, value, url?}]` — sidebar contact block, icon-only (no heading).
  `icon` is a filename (no extension) under `assets/icons/`: currently `mail`, `phone`,
  `map-pin`, `cake`, `id-card`. Add more by dropping a similarly-styled SVG (stroke
  `#1E4FA0`) in that folder — icons are from [Lucide](https://lucide.dev) (ISC license).
  `url` is optional; when present the row becomes clickable (`mailto:`, `tel:`, a maps
  link, …)
- `languages`: `[{name, detail, note?}]`
- `strengths`: `["…"]` — rendered as pills
- `skills`: `[{category, items}]`
- `interests`: `[{name, detail}]`
- `certifications`, `first_aid`: `["…"]` — simple bullet lists
- `education`, `experience`: `[{period, title, org?, description?}]` — rendered as a timeline
- `activities`: `[{title, org?, description?}]`

## Photo

`assets/photo.jpg` is currently a tight crop taken from the old CV screenshot,
so it's a bit soft. Drop a higher-resolution square photo at the same path
(or update `data.json`'s `photo` field to point elsewhere) and rebuild.

## Fonts

`fonts/` bundles two free families — the `--font-path fonts` flag is required
at compile time since neither is installed system-wide:

- **Inter** (OFL) — body text, sidebar, timeline.
- **EB Garamond** (OFL, variable font) — name + job title in the header only,
  for an editorial serif/sans pairing against the Inter body.

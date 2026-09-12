// ============================================================
// CV Generator — Typst template
// Sleek, Claude-inspired layout in blue. Reads all content from
// a JSON file (default: data.json) so the same template can
// render any CV without touching this file.
// ============================================================

#let data = json(sys.inputs.at("data", default: "data.json"))

// ---------- Localisation ----------
// Section headings default to French; a JSON file can override any of them
// via a "labels" object, and set hyphenation rules via "lang".
#let doc-lang = data.at("lang", default: "fr")
#let labels = data.at("labels", default: (:))
#let t(key, fallback) = labels.at(key, default: fallback)

// ---------- Palette ----------
#let ink = rgb("#1B2430")        // primary text
#let ink-soft = rgb("#5B6672")   // secondary text
#let ink-faint = rgb("#8993A1")  // tertiary text
#let blue-900 = rgb("#122E5C")   // headline blue
#let blue-700 = rgb("#1E4FA0")   // primary blue
#let blue-500 = rgb("#3B6FD8")   // accent blue
#let blue-200 = rgb("#BFD3F2")   // rules / rails
#let blue-100 = rgb("#E4ECFB")   // tint fills
#let blue-50  = rgb("#F4F8FE")   // sidebar background
#let hairline = rgb("#E3E7ED")

// ---------- Page & base text ----------
#set page(
  paper: "a4",
  margin: (top: 0.75cm, bottom: 0.7cm, left: 0cm, right: 0cm),
)
#set text(font: "Inter", size: 8.5pt, fill: ink, lang: doc-lang, weight: "regular")
#set par(leading: 0.46em, justify: false)

#let sidebar-w = 6.1cm
#let page-margin = 1.4cm

// ---------- Small helpers ----------
#let dot(fill: blue-500, size: 5pt) = box(width: size, height: size, radius: 50%, fill: fill)

#let sidebar-heading(title) = block(above: 11pt, below: 3pt)[
  #text(font: "EB Garamond", size: 9.5pt, weight: "bold", fill: blue-900, tracking: 1pt)[#upper(title)]
  #v(-6pt)
  #line(length: 100%, stroke: 0.6pt + blue-200)
]

#let main-heading(title) = block(above: 0pt, below: 8pt)[
  #text(font: "EB Garamond", size: 12.5pt, weight: "bold", fill: blue-900, tracking: 0.6pt)[#upper(title)]
  #v(-7pt)
  #line(length: 100%, stroke: 1pt + blue-500)
]

#let icon-row(icon, value, url: none) = block(below: 5.5pt)[
  #let row = grid(
    columns: (10pt, 1fr),
    column-gutter: 6.5pt,
    align(horizon + left)[#image("assets/icons/" + icon + ".svg", width: 9.5pt, height: 9.5pt)],
    align(horizon)[#text(size: 8.3pt, fill: ink)[#value]],
  )
  #if url != none [#link(url)[#row]] else [#row]
]

#let pill(txt) = box(
  fill: blue-100,
  radius: 3pt,
  inset: (x: 5pt, y: 3pt),
)[#text(size: 7.5pt, fill: blue-900, weight: "medium")[#txt]]

#let skill-row(category, items) = block(below: 8pt)[
  #text(size: 7.8pt, weight: "semibold", fill: ink)[#category]
  #v(0pt)
  #text(size: 7.9pt, fill: ink-soft)[#items]
]

#let simple-list(items) = block[
  #for it in items [
    #let is-linked = type(it) == dictionary
    #let label = if is-linked { it.text } else { it }
    #let url = if is-linked { it.at("url", default: none) } else { none }
    #grid(
      columns: (auto, 1fr),
      column-gutter: 5pt,
      align(top)[#text(fill: blue-500, size: 7.6pt)[–]],
      {
        let entry = text(size: 7.8pt, fill: ink-soft)[#label]
        if url != none { link(url)[#entry] } else { entry }
      },
    )
    #v(1pt)
  ]
]

// A single timeline entry in the main column: a left rail with a
// dot marker, a date label, a title / org line, and a description.
#let timeline-entry(period, title, org, description: none, last: false) = grid(
  columns: (2.95cm, 1fr),
  column-gutter: 0.35cm,
  [
    #align(right)[
      #text(size: 7.4pt, weight: "medium", fill: ink-faint, tracking: 0pt)[#period]
    ]
  ],
  block(
    stroke: (left: 1.3pt + hairline),
    inset: (left: 13pt, bottom: if last { 0pt } else { 9pt }, top: 0pt),
    breakable: false,
  )[
    #place(left, dx: -16.25pt, dy: 3.1pt)[#dot(size: 6.5pt)]
    #text(size: 9.2pt, weight: "semibold", fill: ink)[#title]
    #if org != none [
      #linebreak()
      #text(size: 8.3pt, weight: "medium", fill: blue-700)[#org]
    ]
    #if description != none [
      #v(2pt)
      #text(size: 8pt, fill: ink-soft)[#description]
    ]
  ],
)

#let timeline-section(title, entries) = block(below: 0pt)[
  #main-heading(title)
  #for (i, e) in entries.enumerate() [
    #timeline-entry(
      e.period,
      e.title,
      e.at("org", default: none),
      description: e.at("description", default: none),
      last: i == entries.len() - 1,
    )
  ]
]

// ============================================================
// Sidebar background — placed first so it sits behind the body
// sidebar column, starting right below the header divider and
// running to the bottom of the page.
// ============================================================
#place(top + left, dy: 3.29cm)[
  #box(width: 6.6cm, height: 100%, fill: blue-50)
]

// ============================================================
// Header
// ============================================================
#block(
  inset: (left: 1.4cm, right: 1.4cm, top: 0pt, bottom: 6pt),
)[
  #grid(
    columns: (auto, 1fr, auto),
    column-gutter: 16pt,
    align: horizon,
    // Photo
    if "photo" in data and data.photo != none [
      #box(
        width: 78pt, height: 78pt, radius: 50%, clip: true,
      )[#image(data.photo, width: 78pt, height: 78pt, fit: "cover")]
    ] else [],
    // Name / title / tagline
    [
      #text(font: "EB Garamond", size: 19pt, weight: "semibold", fill: blue-900)[#data.name]
      #v(-3pt)
      #text(font: "EB Garamond", size: 9.4pt, weight: "bold", fill: blue-700, tracking: 0.8pt)[#upper(data.title)]
      #if "tagline" in data and data.tagline != none [
        #v(3pt)
        #text(size: 8pt, fill: ink-soft, style: "italic")[#data.tagline]
      ]
    ],
    // Social links, top-right
    if "social" in data [
      #align(right)[
        #for s in data.social [
          #let row = text(size: 8pt, fill: ink-soft)[
            #text(fill: blue-500, weight: "semibold")[#s.label] #h(2pt) #s.value
          ]
          #if "url" in s and s.url != none [#link(s.url)[#row]] else [#row]
          #v(2pt)
        ]
      ]
    ] else [],
  )
]

#line(length: 100%, stroke: 0.7pt + hairline)

// ============================================================
// Body — sidebar + main column
// ============================================================
#grid(
  columns: (6.6cm, 1fr),
  gutter: 0pt,
  // ---------------- Sidebar ----------------
  block(
    width: 100%,
    inset: (left: 1.4cm, right: 0.6cm, top: 5pt, bottom: 4pt),
  )[
    #if "quick_info" in data [
      #for c in data.quick_info [#icon-row(c.icon, c.value, url: c.at("url", default: none))]
      #v(2pt)
    ]

    #if "languages" in data [
      #sidebar-heading(t("languages", "Langues"))
      #for l in data.languages [
        #block(below: 8pt)[
          #text(size: 8.2pt, weight: "semibold", fill: ink)[#l.name]
          #v(0pt)
          #text(size: 7.8pt, fill: ink-soft)[#l.detail]
          #if "note" in l and l.note != none [
            #linebreak()
            #text(size: 7.3pt, fill: ink-faint)[#l.note]
          ]
        ]
      ]
      #v(2pt)
    ]

    #if "strengths" in data [
      #sidebar-heading(t("strengths", "Atouts"))
      #block[
        #for s in data.strengths [#pill(s) #h(3pt, weak: true) ]
      ]
      #v(2pt)
    ]

    #if "skills" in data [
      #sidebar-heading(t("skills", "Compétences"))
      #for sk in data.skills [#skill-row(sk.category, sk.items)]
      #v(2pt)
    ]

    #if "interests" in data [
      #sidebar-heading(t("interests", "Centres d'intérêt"))
      #for it in data.interests [
        #block(below: 8pt)[
          #text(size: 8.2pt, weight: "semibold", fill: ink)[#it.name]
          #v(0pt)
          #text(size: 7.8pt, fill: ink-soft)[#it.detail]
        ]
      ]
      #v(2pt)
    ]

    #if "certifications" in data [
      #sidebar-heading(t("certifications", "Certifications"))
      #simple-list(data.certifications)
      #v(2pt)
    ]

    #if "first_aid" in data [
      #sidebar-heading(t("first_aid", "Premiers secours"))
      #simple-list(data.first_aid)
    ]
  ],

  // ---------------- Main column ----------------
  block(
    inset: (left: 0.85cm, right: 1.4cm, top: 10pt, bottom: 10pt),
  )[
    #if "experience" in data [
      #timeline-section(t("experience", "Expérience"), data.experience)
      #v(13pt)
    ]

    #if "education" in data [
      #timeline-section(t("education", "Diplômes & Formations"), data.education)
      #v(13pt)
    ]

    #if "activities" in data [
      #main-heading(t("activities", "Activités associatives"))
      #for a in data.activities [
        #block(below: 5pt)[
          #text(size: 9.2pt, weight: "semibold", fill: ink)[#a.title]
          #if "org" in a and a.org != none [
            #h(4pt)
            #text(size: 8.3pt, weight: "medium", fill: blue-700)[#a.org]
          ]
          #if "description" in a and a.description != none [
            #v(2pt)
            #text(size: 8pt, fill: ink-soft)[#a.description]
          ]
        ]
      ]
    ]
  ],
)


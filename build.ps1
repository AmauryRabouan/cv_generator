# Compiles the CV to PDF using the bundled Inter font.
# Usage:
#   .\build.ps1                       -> reads data.json,    writes cv.pdf
#   .\build.ps1 -Lang en              -> reads data.en.json, writes cv.en.pdf
#   .\build.ps1 -Data other.json -Out other.pdf

param(
    [ValidateSet("fr", "en")]
    [string]$Lang = "fr",
    [string]$Data,
    [string]$Out
)

$suffix = if ($Lang -eq "fr") { "" } else { ".$Lang" }
if (-not $Data) { $Data = "data$suffix.json" }
if (-not $Out)  { $Out  = "cv$suffix.pdf" }

typst compile --font-path fonts --input "data=$Data" main.typ $Out

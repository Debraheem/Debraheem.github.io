#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CV_DIR="$ROOT_DIR/CV/Ebraheem_CV"

ruby "$ROOT_DIR/scripts/generate_site_cv.rb"

cd "$CV_DIR"
latexmk -pdf -interaction=nonstopmode -halt-on-error eb_cv_current.tex

cp "$CV_DIR/eb_cv_current.pdf" "$ROOT_DIR/Ebraheem_Farag_CV.pdf"
"$ROOT_DIR/scripts/assemble_dist.sh"

printf 'Build complete:\n'
printf '  CV source: %s\n' "$CV_DIR/eb_cv_current.tex"
printf '  CV pdf:    %s\n' "$ROOT_DIR/Ebraheem_Farag_CV.pdf"
printf '  Site dist: %s\n' "$ROOT_DIR/dist"

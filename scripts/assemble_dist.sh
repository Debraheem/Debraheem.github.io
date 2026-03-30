#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"

mkdir -p "$DIST_DIR/headshot" "$DIST_DIR/plots"

cp "$ROOT_DIR/index.html" "$DIST_DIR/index.html"
cp "$ROOT_DIR/styles.css" "$DIST_DIR/styles.css"
cp "$ROOT_DIR/site.js" "$DIST_DIR/site.js"
cp "$ROOT_DIR/site-data.js" "$DIST_DIR/site-data.js"
cp "$ROOT_DIR/Ebraheem_Farag_CV.pdf" "$DIST_DIR/Ebraheem_Farag_CV.pdf"
cp "$ROOT_DIR/headshot/IMG_6735eb.jpg" "$DIST_DIR/headshot/IMG_6735eb.jpg"
cp "$ROOT_DIR"/plots/*.png "$DIST_DIR/plots/"

if [[ -f "$ROOT_DIR/CNAME" ]]; then
  cp "$ROOT_DIR/CNAME" "$DIST_DIR/CNAME"
fi

touch "$DIST_DIR/.nojekyll"

printf 'Dist assembled at %s\n' "$DIST_DIR"

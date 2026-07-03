#!/usr/bin/env bash
# host.sh - push a local image to this public repo, print its raw URL.
# Purpose: mint a public URL the image-gen MCP can fetch server-side.
# HARD rule: public/disposable art only. Never proprietary/unreleased art.
set -euo pipefail

REPO="BiswajeetLila/Image-Hosting-for-LILA-Art-Skills"
BRANCH="main"

if [ "${1:-}" = "--rm" ]; then
  # delete a previously-hosted file: host.sh --rm seeds/misc/foo-123.png
  P="${2:?path-in-repo required}"
  SHA=$(gh api "repos/$REPO/contents/$P" --jq '.sha')
  gh api "repos/$REPO/contents/$P" -X DELETE -f message="prune hosted image" -f sha="$SHA" >/dev/null
  echo "deleted $P"; exit 0
fi

SRC="${1:?usage: host.sh <local-image> [skill-subdir]}"
SKILL="${2:-misc}"
[ -f "$SRC" ] || { echo "no such file: $SRC" >&2; exit 1; }

EXT="${SRC##*.}"
BASE=$(basename "$SRC" ".$EXT" | tr -c 'A-Za-z0-9_-' '-')
TS=$(date +%s)
DEST="seeds/$SKILL/$BASE-$TS.$EXT"
B64=$(base64 -w0 "$SRC" 2>/dev/null || base64 "$SRC" | tr -d '\n')

gh api "repos/$REPO/contents/$DEST" -X PUT \
  -f message="host $DEST" -f content="$B64" -f branch="$BRANCH" \
  --jq '.content.download_url'

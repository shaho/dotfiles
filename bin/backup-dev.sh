#!/bin/bash
set -euo pipefail

SRC="$HOME/Desktop/dev/"
DEST="$HOME/Library/CloudStorage/Dropbox/dev/"
EXCLUDES="$HOME/.dev-backup-exclude"
LOCK="${TMPDIR:-/tmp}/backup-dev.lock"

# Don't sync into a dead local folder if Dropbox isn't mounted
if [ ! -d "$HOME/Library/CloudStorage/Dropbox" ]; then
  echo "Dropbox folder not found. Open Dropbox and sign in, then rerun." >&2
  exit 1
fi

# One backup at a time
if ! mkdir "$LOCK" 2>/dev/null; then
  echo "Another backup is already running (or remove stale lock: $LOCK)" >&2
  exit 1
fi
trap 'rmdir "$LOCK"' EXIT

mkdir -p "$DEST"

# Prefer Homebrew rsync 3.x (has a real progress bar); fall back to macOS openrsync
RSYNC=rsync
for r in /opt/homebrew/bin/rsync /usr/local/bin/rsync; do
  if [ -x "$r" ]; then RSYNC="$r"; break; fi
done

RSYNC_ARGS=(-a --delete --prune-empty-dirs --exclude-from="$EXCLUDES")

if "$RSYNC" --version 2>/dev/null | grep -Eq 'version 3\.'; then
  # --no-inc-recursive so the percentage is accurate from the start
  caffeinate -i "$RSYNC" "${RSYNC_ARGS[@]}" --info=progress2 --no-inc-recursive "$SRC" "$DEST"
else
  # openrsync has no overall progress, so count changes first and draw our own bar
  tmp=$(mktemp)
  trap 'rmdir "$LOCK"; rm -f "$tmp"' EXIT
  "$RSYNC" "${RSYNC_ARGS[@]}" --dry-run -v "$SRC" "$DEST" >"$tmp" &
  scan=$!
  while kill -0 "$scan" 2>/dev/null; do
    printf '\rScanning for changes... %d found' \
      "$(grep -Evc '^(sent |total size|building file list|$)' "$tmp" || true)"
    sleep 0.2
  done
  wait "$scan"
  total=$(grep -Evc '^(sent |total size|building file list|$)' "$tmp" || true)
  printf '\rScanning for changes... %d to sync\n' "$total"
  if [ "$total" -eq 0 ]; then
    echo "Already up to date."
  else
    caffeinate -i "$RSYNC" "${RSYNC_ARGS[@]}" -v "$SRC" "$DEST" \
      | awk -v total="$total" '
          /^(sent |total size|building file list)/ { next }
          /^$/ { next }
          {
            n++
            pct = int(n * 100 / total); if (pct > 100) pct = 100
            filled = int(pct * 40 / 100)
            bar = substr("########################################", 1, filled)
            printf "\r[%-40s] %3d%%  (%d/%d files)", bar, pct, n, total
          }
          END { printf "\n" }'
  fi
fi

echo "Backup done: $(date)"

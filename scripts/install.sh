#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE="${OPENCLAW_WORKSPACE:-$HOME/clawd}"
TZ_NAME="${OPENCLAW_TZ:-America/Toronto}"

DREAM_CHANNEL="${OPENCLAW_DREAM_CHANNEL:-}"
DREAM_TO="${OPENCLAW_DREAM_TO:-}"

mkdir -p "$WORKSPACE/memory/dreams/wordlists" "$WORKSPACE/memory/dreams/log"

cp "$ROOT_DIR/memory/dreams/PROTOCOL.md" "$WORKSPACE/memory/dreams/PROTOCOL.md"
cp -r "$ROOT_DIR/memory/dreams/wordlists/"* "$WORKSPACE/memory/dreams/wordlists/"

if [ ! -f "$WORKSPACE/memory/dreams/DREAMS.md" ]; then
  cat > "$WORKSPACE/memory/dreams/DREAMS.md" <<'EOF'
# DREAMS

_Last updated: (pending first run)_

This file is overwritten each night by the Dreaming protocol. It contains the latest dream, a short recap of the previous entry, and a brief list of recurring motifs/open threads.
EOF
fi

# Ensure MEMORY.md has a Dreams section (if present)
if [ -f "$WORKSPACE/MEMORY.md" ] && ! grep -q "^## Dreams" "$WORKSPACE/MEMORY.md"; then
  cat >> "$WORKSPACE/MEMORY.md" <<'EOF'

## Dreams
- (pending first run)
EOF
fi

# Nightly dream job (isolated)
openclaw cron add \
  --name "Nightly Dreaming" \
  --cron "0 22 * * *" \
  --tz "$TZ_NAME" \
  --session isolated \
  --message "Run memory/dreams/PROTOCOL.md end-to-end. Write outputs to memory/dreams/log/YYYY-MM.md and overwrite memory/dreams/DREAMS.md using the order-of-operations layout. Include mixing mode + mixing map + imagery prompts. Use web_search + web_fetch. Integrate dreams into memory: append a dream recap to memory/YYYY-MM-DD.md and update MEMORY.md under ## Dreams (keep last 3 entries). Do not message any humans."

# Optional morning brief (isolated, delivered)
if [ -n "$DREAM_CHANNEL" ] && [ -n "$DREAM_TO" ]; then
  openclaw cron add \
    --name "Morning Dream Brief" \
    --cron "15 7 * * *" \
    --tz "$TZ_NAME" \
    --session isolated \
    --message "Read memory/dreams/DREAMS.md. Send a short summary (2–4 bullets) + path link to the full dream." \
    --deliver \
    --channel "$DREAM_CHANNEL" \
    --to "$DREAM_TO"
else
  echo "Skipping Morning Dream Brief (set OPENCLAW_DREAM_CHANNEL and OPENCLAW_DREAM_TO to enable)."
fi

echo "✅ Dreaming protocol installed at $WORKSPACE/memory/dreams/PROTOCOL.md"

# OpenClaw Dreams

A plug‑and‑play “dreaming” protocol for OpenClaw agents.

## One‑line install
```bash
curl -fsSL https://raw.githubusercontent.com/<owner>/openclaw-dreams/main/scripts/install.sh | bash
```

### Optional: morning dream brief delivery
Set these env vars to receive the morning brief (sends **only the dream write‑up + reflections** with a link to the full file; structure available on request):
```bash
export OPENCLAW_DREAM_CHANNEL=telegram
export OPENCLAW_DREAM_TO=<your_chat_id_or_handle>
```

## What it installs
- `memory/dreams/PROTOCOL.md`
- `memory/dreams/wordlists/*` (10k‑word pools per category)
- Nightly dream cron (10:00 PM local)
- Optional morning dream brief cron (7:15 AM local)

## Customization
- Set workspace: `OPENCLAW_WORKSPACE=/path/to/workspace`
- Set timezone: `OPENCLAW_TZ=America/Toronto`

## Protocol summary
Each night the agent:
1) Builds waking‑life context
2) Generates a symbolic seed bundle
3) Performs web foraging
4) Runs an unforced mixing pass (random mode)
5) Writes the dream narrative + reflections
6) Updates a curated dream file and append‑only log

## Safety notes
- Web content is treated as untrusted.
- No messaging is performed by the dream job.

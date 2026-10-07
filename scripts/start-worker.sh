#!/usr/bin/env bash
# Start a long-lived My Machines worker for phone-triggered local edits.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="${CURSOR_MY_MACHINES_CONFIG:-$ROOT/config/my-machines.env}"

log() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

# Ensure common CLI install path is available when launched from launchd
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

command -v agent >/dev/null 2>&1 || die "agent CLI not found. Run ./scripts/setup-my-machines.sh first."

if [[ -f "$CONFIG" ]]; then
  # shellcheck disable=SC1090
  source "$CONFIG"
else
  log "No config at $CONFIG — using defaults. Copy config/my-machines.env.example to config/my-machines.env"
fi

WORKER_NAME="${WORKER_NAME:-home-mac}"
# Default to the repo that contains this script
WORKER_DIRS="${WORKER_DIRS:-$ROOT}"

args=(--name "$WORKER_NAME")

# WORKER_DIRS is a colon-separated list of absolute paths
IFS=':' read -r -a dirs <<< "$WORKER_DIRS"
for dir in "${dirs[@]}"; do
  [[ -n "$dir" ]] || continue
  [[ -d "$dir" ]] || die "worker dir does not exist: $dir"
  args+=(--worker-dir "$dir")
done

if [[ "${COMPUTER_USE:-0}" == "1" ]]; then
  args+=(--computer-use)
fi

if [[ -n "${CURSOR_API_KEY:-}" ]]; then
  args+=(--api-key "$CURSOR_API_KEY")
fi

log "Starting My Machines worker"
log "  name: $WORKER_NAME"
log "  dirs: $WORKER_DIRS"
log "Keep this process running (Amphetamine / launchd). From your phone, pick My Machines → $WORKER_NAME"

exec agent worker "${args[@]}" start
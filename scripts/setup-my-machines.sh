#!/usr/bin/env bash
# Install the Cursor CLI and sign in for My Machines (run on your Mac).
set -euo pipefail

log() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

if [[ "$(uname -s)" != "Darwin" ]]; then
  log "Warning: this script is intended for macOS. Continuing anyway."
fi

if ! command -v agent >/dev/null 2>&1; then
  log "Installing Cursor CLI"
  curl https://cursor.com/install -fsS | bash

  # Common install locations for the Cursor agent CLI
  for dir in "$HOME/.local/bin" "/usr/local/bin"; do
    if [[ -x "$dir/agent" ]]; then
      export PATH="$dir:$PATH"
      break
    fi
  done
fi

command -v agent >/dev/null 2>&1 || die "agent CLI not found on PATH after install. Open a new terminal and retry."

log "CLI version:"
agent --version

if [[ "${SKIP_LOGIN:-0}" == "1" ]]; then
  log "Skipping login (SKIP_LOGIN=1)"
else
  log "Signing in (browser will open; use the same account as on your phone)"
  agent login
fi

log "Running worker preflight"
agent worker debug || log "worker debug reported issues; fix auth/network, then retry."

log "Setup complete. Next: ./scripts/start-worker.sh"
#!/usr/bin/env bash
# Install a macOS LaunchAgent so the My Machines worker restarts at login.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LABEL="com.cursor.my-machines-worker"
PLIST_SRC="$ROOT/macos/${LABEL}.plist"
PLIST_DST="$HOME/Library/LaunchAgents/${LABEL}.plist"
START_SCRIPT="$ROOT/scripts/start-worker.sh"

log() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

[[ "$(uname -s)" == "Darwin" ]] || die "LaunchAgents are macOS-only. On Linux, use systemd or tmux."
[[ -f "$PLIST_SRC" ]] || die "Missing template: $PLIST_SRC"
[[ -x "$START_SCRIPT" ]] || die "Make start-worker.sh executable first"

LOG_DIR="$HOME/Library/Logs/cursor-my-machines"
mkdir -p "$HOME/Library/LaunchAgents" "$LOG_DIR"

# Substitute absolute paths into the plist (launchd does not expand ~)
sed \
  -e "s|__START_WORKER_SCRIPT__|${START_SCRIPT}|g" \
  -e "s|__LOG_DIR__|${LOG_DIR}|g" \
  -e "s|__HOME__|${HOME}|g" \
  "$PLIST_SRC" > "$PLIST_DST"

log "Installed $PLIST_DST"

if launchctl print "gui/$(id -u)/$LABEL" >/dev/null 2>&1; then
  log "Reloading existing LaunchAgent"
  launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
fi

launchctl bootstrap "gui/$(id -u)" "$PLIST_DST"
launchctl enable "gui/$(id -u)/$LABEL"
launchctl kickstart -k "gui/$(id -u)/$LABEL"

log "Worker LaunchAgent started."
log "Logs: ~/Library/Logs/cursor-my-machines/worker.stdout.log"
log "Unload later with: launchctl bootout gui/\$(id -u)/$LABEL"
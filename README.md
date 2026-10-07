# Phone → local Cursor edits (My Machines)

Keep your Mac awake (Amphetamine), run a Cursor **My Machines** worker against your local code, and kick off jobs from your phone. Inference runs in Cursor’s cloud; file edits and terminals run on your Mac.

```text
Phone (Cursor app / cursor.com/agents)
        │
        ▼
Cursor cloud agent loop
        │  HTTPS tool calls
        ▼
Mac: agent worker  →  local code directory
```

## Quick start (on your Mac)

```bash
# 1) Install CLI + sign in (same account as phone)
chmod +x scripts/*.sh
./scripts/setup-my-machines.sh

# 2) Configure worker name / repo paths (optional)
cp config/my-machines.env.example config/my-machines.env
# edit WORKER_NAME and WORKER_DIRS

# 3) Start the worker (leave running)
./scripts/start-worker.sh

# Or install a LaunchAgent so it survives logout/reboot:
./scripts/install-launch-agent.sh
```

Keep Amphetamine (or equivalent) preventing sleep while you are away.

## Issue a job from your phone

See [docs/phone-kickoff.md](docs/phone-kickoff.md).

Short version:

1. Open the Cursor iOS app, or [cursor.com/agents](https://cursor.com/agents) on Android
2. Start an agent
3. Choose **My Machines → home-mac** (or your `WORKER_NAME`)
4. Send the task

## Layout

| Path | Purpose |
|------|---------|
| `scripts/setup-my-machines.sh` | Install Cursor CLI + `agent login` + preflight |
| `scripts/start-worker.sh` | Start long-lived My Machines worker |
| `scripts/install-launch-agent.sh` | Keep worker alive via macOS LaunchAgent |
| `macos/com.cursor.my-machines-worker.plist` | LaunchAgent template |
| `config/my-machines.env.example` | Worker name / dirs / options |
| `docs/phone-kickoff.md` | Phone / Slack / GitHub / Linear triggers |

## Reliability checklist

- Same Cursor account on CLI and phone
- Worker process stays up (foreground script or LaunchAgent)
- `WORKER_DIRS` are real git checkouts (routing uses git remotes)
- If the machine is missing: `agent worker debug`
- Privacy Mode (not Legacy) for mobile/cloud agents

## Docs

- [My Machines](https://cursor.com/docs/cloud-agent/my-machines)
- [Self-Hosted Machines](https://cursor.com/docs/cloud-agent/self-hosted)
- [Cursor for iOS / mobile](https://cursor.com/docs/cloud-agent/mobile)

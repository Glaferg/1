# Phone kickoff (My Machines)

After the Mac worker is running (`./scripts/start-worker.sh` or the LaunchAgent), issue jobs from your phone.

## Prerequisites

- Same Cursor account on the Mac CLI and on the phone
- Privacy Mode enabled (not Privacy Mode Legacy)
- Worker process up; Amphetamine keeping the Mac awake
- Machine name matches `WORKER_NAME` (default: `home-mac`)

## iPhone / iPad

1. Install the Cursor app from the App Store
2. Sign in with the same account used for `agent login`
3. Start a new agent
4. In the run-location picker, choose **My Machines → home-mac** (or your `WORKER_NAME`)
5. Send the task

## Android

1. Open [cursor.com/agents](https://cursor.com/agents) in Chrome
2. Optionally tap **Install App** for a PWA
3. Sign in, start an agent, select **My Machines → home-mac**
4. Send the task

## Other triggers (same named worker)

- Slack: `@Cursor worker=home-mac fix the flaky test`
- GitHub: `@cursoragent worker=home-mac …`
- Linear: put `worker=home-mac` in the issue body

Cursor matches the worker using the git remotes of directories listed in `WORKER_DIRS`.

## If the machine does not appear

On the Mac:

```bash
agent worker debug
./scripts/start-worker.sh
```

Confirm the CLI and phone use the same account, the worker is still running, and `--worker-dir` points at the intended git checkout.

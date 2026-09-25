#!/usr/bin/env bash
# Restart the shell, but never while the session is locked (that would drop
# the lock surface; the persisted state would re-lock, with a red flash).
if [[ "$(qs -c nothing ipc call lock isLocked 2>/dev/null)" == "true" ]]; then
    echo "restart.sh: session is locked, not restarting" >&2
    exit 1
fi
pkill -x qs; pkill -x quickshell; sleep 0.3
setsid qs -c nothing >"${1:-/dev/null}" 2>&1 </dev/null &

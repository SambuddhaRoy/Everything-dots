#!/usr/bin/env bash
# Everything-dots auto-updater (run by everything-dots-update.timer).
# Fast-forwards the repo, re-links configs, reloads Hyprland and restarts the
# shell - unless you have local edits, or the screen is locked.
set -uo pipefail
DOTS="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
cd "$DOTS" || exit 1

# Reach the running Hyprland session from a systemd user service.
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
if [[ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    sig=$(ls -t "$XDG_RUNTIME_DIR/hypr" 2>/dev/null | head -n1)
    [[ -n "$sig" ]] && export HYPRLAND_INSTANCE_SIGNATURE="$sig"
fi
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
notify() { command -v notify-send >/dev/null && notify-send -a Everything-dots "$@"; }

git fetch --quiet origin || exit 0
[[ "$(git rev-parse @)" == "$(git rev-parse '@{u}')" ]] && exit 0
if ! git diff --quiet || ! git diff --cached --quiet; then
    notify "Update available" "Skipped: you have local changes in ${DOTS/#$HOME/~}"
    exit 0
fi
before=$(git rev-parse --short @)
git pull --ff-only --quiet || { notify "Update failed" "git pull couldn't fast-forward"; exit 1; }

"$DOTS/install.sh" --link-only --quiet

# New packages upstream? Say so rather than sudo-ing unattended.
if git diff --name-only "$before" @ | grep -qx install.sh; then
    notify "Everything-dots updated" "The installer changed - run ~/Everything-dots/install.sh to pick up new packages"
fi

if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    hyprctl reload >/dev/null 2>&1
    "$HOME/.config/quickshell/nothing/scripts/restart.sh" >/dev/null 2>&1 # refuses while locked
fi
notify "Everything-dots updated" "$(git log -1 --format=%s)"

#!/usr/bin/env bash
set -euo pipefail

LAYOUT="${1:-us}"

if ! command -v setxkbmap >/dev/null 2>&1; then
  sudo pacman -S --needed xkeyboard-config
fi

# Apply now (works on X11 sessions)
setxkbmap "$LAYOUT"

# Persist for LXDE
mkdir -p "$HOME/.config/lxsession/LXDE"
AUTOSTART="$HOME/.config/lxsession/LXDE/autostart"

touch "$AUTOSTART"

if grep -q "@setxkbmap " "$AUTOSTART"; then
  # Replace existing setxkbmap line(s)
  sed -i "s|^@setxkbmap .*|@setxkbmap ${LAYOUT}|g" "$AUTOSTART" || true
else
  echo "@setxkbmap ${LAYOUT}" >> "$AUTOSTART"
fi

echo "Keyboard layout set to: $LAYOUT"
echo "Log out and log back in to ensure LXDE uses it."

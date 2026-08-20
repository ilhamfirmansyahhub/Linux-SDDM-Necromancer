#!/usr/bin/env bash
set -euo pipefail

THEME_NAME="necromancer-sddm"
SRC_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DST_DIR="/usr/share/sddm/themes/${THEME_NAME}"
CONF_DIR="/etc/sddm.conf.d"
CONF_FILE="${CONF_DIR}/99-${THEME_NAME}.conf"

sudo mkdir -p "$DST_DIR/assets" "$CONF_DIR"
sudo cp -a "$SRC_DIR"/Main.qml "$SRC_DIR"/metadata.desktop "$SRC_DIR"/theme.conf "$DST_DIR"/

if [[ -f "$SRC_DIR/assets/background.jpg" ]]; then
    sudo cp "$SRC_DIR/assets/background.jpg" "$DST_DIR/assets/background.jpg"
elif [[ ! -f "$DST_DIR/assets/background.jpg" ]]; then
    echo "Warning: assets/background.jpg was not found."
    echo "Copy your WallpaperFlare 2560x1440 image to:"
    echo "  $DST_DIR/assets/background.jpg"
fi

cat <<CFG | sudo tee "$CONF_FILE" >/dev/null
[Theme]
Current=${THEME_NAME}
CFG

printf '\nInstalled %s.\n' "$THEME_NAME"
printf 'Preview with:\n  sddm-greeter-qt6 --test-mode --theme %s\n\n' "$DST_DIR"

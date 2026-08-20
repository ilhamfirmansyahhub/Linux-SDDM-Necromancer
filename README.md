# Necromancer SDDM

A compact Qt6 SDDM theme inspired by the supplied reference design and built around a dark post-apocalyptic wallpaper.

## Features

- Wallpaper-first layout with no large panel behind the login form
- Compact bordered username, password, and Login controls
- Clickable user selector above the login form
- Clickable session selector in the bottom-left corner
- Smooth hover and menu animations
- Qt6 / QML based SDDM greeter theme
- Installer that preserves an existing `background.jpg`

## Background

The theme expects a 2560×1440 WallpaperFlare image at:

```text
assets/background.jpg
```

The wallpaper is not bundled in this repository. Download it from the WallpaperFlare page used for this theme and place it at the path above.

## Install

```bash
git clone https://github.com/ilhamfirmansyahhub/Linux-SDDM-Necromancer.git
cd Linux-SDDM-Necromancer
mkdir -p assets
# place your downloaded background.jpg in assets/
sudo ./install.sh
```

To preview without logging out:

```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/necromancer-sddm
```

## Notes

The installer enables the theme through `/etc/sddm.conf.d/99-necromancer-sddm.conf` and installs files under `/usr/share/sddm/themes/necromancer-sddm`.

## License

MIT

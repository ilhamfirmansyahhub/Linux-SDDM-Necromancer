# Necromancer SDDM

A small Qt6/QML theme for SDDM with a dark post-apocalyptic look. The layout is kept simple so the wallpaper stays visible instead of sitting behind a large login panel.


## What it includes

- Compact username and password fields
- Bordered login button
- User selection above the login form
- Session selection in the bottom-left corner
- Simple hover and menu animations
- Qt6/QML SDDM greeter
- Installer script for setting the theme up

## Wallpaper

The theme was made around this 2560×1440 wallpaper from WallpaperFlare:

https://www.wallpaperflare.com/zombie-apocalypse-post-apocalypse-hackerman-hack-hacking-wallpaper-yisws/download/2560x1440

The image is not included in the repository. Download it manually and save it as:

```text
assets/background.jpg
```

The filename needs to be exactly `background.jpg`.

## Requirements

You need:

- SDDM
- A Qt6-compatible SDDM greeter
- Git
- A Linux desktop using SDDM

On Arch Linux or CachyOS, SDDM can be installed with:

```bash
sudo pacman -S sddm
```

If SDDM is already installed and working, there is nothing else to install.

## Install

Clone the repository:

```bash
git clone https://github.com/ilhamfirmansyahhub/Linux-SDDM-Necromancer.git
cd Linux-SDDM-Necromancer
```

Create the assets directory and put the wallpaper there:

```bash
mkdir -p assets
```

After downloading the wallpaper, make sure this file exists:

```text
assets/background.jpg
```

Then run the installer:

```bash
chmod +x install.sh
sudo ./install.sh
```

The theme is installed to:

```text
/usr/share/sddm/themes/necromancer-sddm
```

and SDDM is configured to use it through:

```text
/etc/sddm.conf.d/99-necromancer-sddm.conf
```

## Preview

You can test the theme before logging out:

```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/necromancer-sddm
```

Depending on the distribution, the greeter executable may have a different name. You can check with:

```bash
command -v sddm-greeter
command -v sddm-greeter-qt6
```

Once everything looks right, log out or reboot and SDDM should load the theme normally.

## Layout

The current layout is roughly:

```text
                         Clock
                          Date

                       User selector
                       Username field
                       Password field
                          Login

[ Session selector ]
```

The login area is intentionally small and sits directly over the wallpaper.

## Files

```text
Main.qml          Main UI and login logic
theme.conf        Theme settings
metadata.desktop  SDDM theme metadata
install.sh        Installation script
assets/           Wallpaper file
```

The main UI can be adjusted in `Main.qml`. After making changes, run the installer again.

## Uninstall

Remove the theme:

```bash
sudo rm -rf /usr/share/sddm/themes/necromancer-sddm
```

Remove the SDDM configuration:

```bash
sudo rm -f /etc/sddm.conf.d/99-necromancer-sddm.conf
```

Then choose another SDDM theme or set another theme in your SDDM configuration.

## Compatibility

This theme is mainly developed and tested on Arch Linux / CachyOS with SDDM.

It should work on other distributions as long as they provide a compatible Qt6 SDDM greeter. SDDM configuration paths and package names may be different depending on the distro.

## Troubleshooting

### Wallpaper is not showing

Check that the file was installed:

```bash
ls -lh /usr/share/sddm/themes/necromancer-sddm/assets/background.jpg
```

If it is missing, copy it again:

```bash
sudo mkdir -p /usr/share/sddm/themes/necromancer-sddm/assets
sudo cp assets/background.jpg /usr/share/sddm/themes/necromancer-sddm/assets/
```

### SDDM is not using the theme

Check the configuration:

```bash
cat /etc/sddm.conf.d/99-necromancer-sddm.conf
```

It should contain:

```ini
[Theme]
Current=necromancer-sddm
```

Also check that SDDM is enabled:

```bash
systemctl is-enabled sddm
```

## Credits

Theme by **ilhamfirmansyahhub**.

Background: WallpaperFlare (link above).

## License

MIT

# Necromancer SDDM

A compact **Qt6/QML SDDM theme** with a dark post-apocalyptic aesthetic, designed to keep the wallpaper visible while providing a clean, minimal login interface.

![Necromancer SDDM](https://raw.githubusercontent.com/ilhamfirmansyahhub/Linux-SDDM-Necromancer/main/assets/background.jpg)

## ✨ Features

- Wallpaper-first design with no large panel behind the login form
- Compact bordered username, password, and **Login** controls
- Clickable **user selector** above the login form
- Clickable **session selector** in the bottom-left corner
- Smooth hover and menu animations
- Qt6 / QML based SDDM greeter
- Simple installer for Arch Linux and other distributions using SDDM
- Existing `background.jpg` is preserved by the installer

## 📸 Background

The theme uses a 2560×1440 post-apocalyptic wallpaper from WallpaperFlare.

The wallpaper is **not bundled with this repository**. You need to download it yourself and save it as:

```text
assets/background.jpg
```

Wallpaper source:

<https://www.wallpaperflare.com/zombie-apocalypse-post-apocalypse-hackerman-hack-hacking-wallpaper-yisws/download/2560x1440>

Make sure the downloaded file is named exactly `background.jpg`.

## 📦 Requirements

Before installing, make sure your system has:

- SDDM
- Qt6 / QtQuick support for your SDDM build
- `git`
- `curl` or `wget`

On Arch Linux / CachyOS, SDDM can be installed with:

```bash
sudo pacman -S sddm
```

If you already use SDDM, you do not need to install it again.

## 🚀 Installation

### 1. Clone the repository

```bash
git clone https://github.com/ilhamfirmansyahhub/Linux-SDDM-Necromancer.git
cd Linux-SDDM-Necromancer
```

### 2. Add the wallpaper

Create the assets directory if it does not already exist:

```bash
mkdir -p assets
```

Download the **2560×1440** wallpaper from WallpaperFlare using your browser and save it as:

```text
assets/background.jpg
```

Check that the file exists:

```bash
ls -lh assets/background.jpg
```

### 3. Install the theme

Make the installer executable:

```bash
chmod +x install.sh
```

Run it as root:

```bash
sudo ./install.sh
```

The installer will install the theme to:

```text
/usr/share/sddm/themes/necromancer-sddm
```

and enable it using:

```text
/etc/sddm.conf.d/99-necromancer-sddm.conf
```

### 4. Preview before logging out

You can test the greeter from your current desktop session:

```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/necromancer-sddm
```

This lets you check the layout without immediately logging out of your desktop.

### 5. Log out or reboot

After confirming the preview looks correct, log out or reboot. SDDM should now use the **Necromancer** theme automatically.

## 🎨 Layout

The theme is arranged as follows:

```text
                         Clock
                          Date

                       User selector
                       Username field
                       Password field
                          Login

[ Session selector ]
```

The login form is intentionally compact and sits directly over the wallpaper without a large background panel.

## ⚙️ Configuration

The main theme files are located in:

```text
/usr/share/sddm/themes/necromancer-sddm/
```

Important files:

```text
Main.qml          # Main UI and behavior
theme.conf        # Theme configuration
metadata.desktop  # SDDM theme metadata
install.sh        # Installer
assets/           # Wallpaper assets
```

To change the appearance, edit `Main.qml` and reinstall the theme.

## 🗑️ Uninstall

Remove the installed theme:

```bash
sudo rm -rf /usr/share/sddm/themes/necromancer-sddm
```

Then remove the SDDM theme selection file:

```bash
sudo rm -f /etc/sddm.conf.d/99-necromancer-sddm.conf
```

After that, select another SDDM theme in your system configuration or create a new SDDM theme configuration.

## 🖥️ Distribution Compatibility

The theme is primarily developed and tested with **Arch Linux / CachyOS + SDDM**.

It should also work on other Linux distributions that provide a compatible **Qt6 SDDM greeter**, but package names and SDDM configuration paths may differ.

## ⚠️ Troubleshooting

### The wallpaper is missing

Make sure this file exists:

```bash
ls -lh /usr/share/sddm/themes/necromancer-sddm/assets/background.jpg
```

If it does not exist, copy your wallpaper again:

```bash
sudo mkdir -p /usr/share/sddm/themes/necromancer-sddm/assets
sudo cp assets/background.jpg /usr/share/sddm/themes/necromancer-sddm/assets/
```

### The theme does not appear

Check which theme SDDM is configured to use:

```bash
cat /etc/sddm.conf.d/99-necromancer-sddm.conf
```

It should contain:

```ini
[Theme]
Current=necromancer-sddm
```

Also verify that SDDM is installed and enabled:

```bash
systemctl is-enabled sddm
```

### The preview command is unavailable

Some distributions use a different SDDM greeter executable. Check which one is installed:

```bash
command -v sddm-greeter
command -v sddm-greeter-qt6
```

Use the executable provided by your distribution.

## 📄 License

MIT

## 🙏 Credits

- Theme and QML implementation: **ilhamfirmansyahhub**
- Background artwork: WallpaperFlare (see source link above)
- Built for the Linux / SDDM ecosystem

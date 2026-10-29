# sddm-astronaut-theme

> [!WARNING]
> This is a personal fork of [Keyitdev's sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme). The badges, previews, and support links below point to the upstream project.

![Stars](https://img.shields.io/github/stars/keyitdev/sddm-astronaut-theme?color=dd864a&labelColor=1b1b25&style=for-the-badge)
![Forks](https://img.shields.io/github/forks/keyitdev/sddm-astronaut-theme?color=bf616a&labelColor=1b1b25&style=for-the-badge)
[![Ko-fi](https://img.shields.io/badge/support_me_on_ko--fi-F16061?style=for-the-badge&logo=kofi&logoColor=f5f5f5)](https://ko-fi.com/keyitdev)

[sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme) is a series of themes for the [SDDM](https://github.com/sddm/sddm/) display manager made by **[Keyitdev](https://github.com/Keyitdev)**.

This fork adds a flake/package for Nix, an account picker in the username field, and a custom `hyprland_kath` background. The original theme and most of the previews remain unchanged.

It's written using the latest version of Qt, which is **Qt6**. Its key features include **virtual keyboard support** and an **installation script**. This theme also support **animated wallpapers**. You can easily change its appearance by choosing another of the ten pre-made themes or creating your own. Each of these themes was created by modifying just one file - **[config](./Themes/astronaut.conf)**.

All themes were created for 1080p. However, they should work well in other resolutions.

## Preview of all themes

![all_themes.gif](https://github.com/Keyitdev/screenshots/blob/master/sddm-astronaut-theme/master/all_themes.gif?raw=true)

## Preview of animated themes

https://github.com/user-attachments/assets/2cfc947e-4621-4e98-b5f3-07d5e224b80c

<!-- <h2><a href="https://youtu.be/4tQ56xh7wBc" target="_blank">Watch more on Youtube!</a></h2> -->
<details>
<summary><h2>Detailed previews</h2></summary>

**Astronaut**|**Black hole**
|:--:|:--:|
![astronaut](https://github.com/Keyitdev/screenshots/blob/master/sddm-astronaut-theme/master/astronaut.png?raw=true)|![black_hole](https://github.com/Keyitdev/screenshots/blob/master/sddm-astronaut-theme/master/black_hole.png?raw=true)
**Japanese aesthetic**|**Pixel sakura static**
![japanese_aesthetic](https://github.com/Keyitdev/screenshots/blob/master/sddm-astronaut-theme/master/japanese_aesthetic.png?raw=true)|![pixel_sakura_static](https://github.com/Keyitdev/screenshots/blob/master/sddm-astronaut-theme/master/pixel_sakura_static.png?raw=true)
**Purple leaves**|**Cyberpunk**
![purple_leaves](https://github.com/Keyitdev/screenshots/blob/master/sddm-astronaut-theme/master/purple_leaves.png?raw=true)|![cyberpunk](https://github.com/Keyitdev/screenshots/blob/master/sddm-astronaut-theme/master/cyberpunk.png?raw=true)
**Post-apocalyptic hacker**|**xxx**
![post-apocalyptic_hacker](https://github.com/Keyitdev/screenshots/blob/master/sddm-astronaut-theme/master/post-apocalyptic_hacker.png?raw=true)|

**Hyprland Kath**

https://github.com/user-attachments/assets/1d926e76-44f7-4d99-ac6d-d1abcd7ed688

**Pixel sakura**

https://github.com/user-attachments/assets/ea004765-7e84-4a0d-90cd-aaac97679f62

**Jake the dog**

https://github.com/user-attachments/assets/181d48c2-f152-45f5-b568-21145be180f6

</details>

## Installation

### Nix Flake

This fork provides a flake with the theme package and checks:

```sh
nix build github:ar175-lol/sddm-astronaut-theme
nix flake check github:ar175-lol/sddm-astronaut-theme
```

The package installs the theme to `share/sddm/themes/sddm-astronaut-theme`.

### Customization

The package can be overridden with a theme name, font family, and custom background:

```nix
let
  sddm-theme = inputs.sddm-astronaut-theme.packages.${pkgs.system}.default.override {
    theme = "astronaut";
    font = "Monocraft";
    background = ./wallpaper.png;
  };
in ...
```

- `theme` selects a config from `Themes/` without the `.conf` suffix. The default is `hyprland_kath`.
- `font` replaces the `Font` setting in the selected config. The font must be installed on the system.
- `background` copies an image or video into the theme and updates its `Background` setting. Leave it as `null` to keep the theme's bundled background.

### NixOS

Add this fork as a flake input:

```nix
{
  inputs.sddm-astronaut-theme.url = "github:ar175-lol/sddm-astronaut-theme";
}
```

Then add the theme to your NixOS configuration:

```nix
{inputs, pkgs, ...}: let
  sddm-theme = inputs.sddm-astronaut-theme.packages.${pkgs.system}.default;
in {
  services.displayManager.sddm = {
    enable = true;
    theme = "${sddm-theme}/share/sddm/themes/sddm-astronaut-theme";
    extraPackages = with pkgs.kdePackages; [
      qtmultimedia
      qtsvg
      qtvirtualkeyboard
    ];
  };
}
```

`qtmultimedia` is required for animated backgrounds, and `qtvirtualkeyboard` provides the on-screen keyboard.

> If `inputs` is not available inside your modules, pass it through `specialArgs` or `extraSpecialArgs`.

## Manual Installation

1. Install **dependencies**

[`sddm >= 0.21.0`](https://github.com/sddm/sddm), [`qt6 >= 6.8`](https://doc.qt.io/qt-6/index.html), [`qt6-svg >= 6.8`](https://doc.qt.io/qt-6/qtsvg-index.html), [`qt6-virtualkeyboard >= 6.8`](https://doc.qt.io/qt-6/qtvirtualkeyboard-index.html), [`qt6-multimedia >= 6.8`](https://doc.qt.io/qt-6/qtmultimedia-index.html)

You may also want to install additional video codecs like h.264.

```sh
sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg     # Arch
sddm qt6-svg qt6-virtualkeyboard qt6-multimedia            # Void
sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia      # Fedora
sddm-qt6 libQt6Svg6 qt6-virtualkeyboard qt6-virtualkeyboard-imports qt6-multimedia qt6-multimedia-imports        # OpenSUSE
sddm qt6-svg-dev qml6-module-qtquick-virtualkeyboard qt6-multimedia-dev qml6-module-qtquick-controls qml6-module-qtquick-effects libxcb-cursor0 # Debian trixie (13.5)
```

2. Clone this repository
```sh
sudo git clone -b master --depth 1 https://github.com/ar175-lol/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
```
3. Configure SDDM to use the theme
```sh
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf
```
4. Enable the virtual keyboard (optional)
```sh
echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf
```

> [!NOTE]
> This fork does not bundle fonts. Install the font used by the selected theme config if it is not already available (for example, `JetBrainsMono Nerd Font`).

## Selecting a theme

You can select theme by editing [metadata](./metadata.desktop) (`/usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop`).

Just edit this line:
```
ConfigFile=Themes/astronaut.conf
```
All available configs are in [Themes](./Themes/) directory.

When using the flake, set `theme = "astronaut"` in the package override instead of editing `metadata.desktop`.

## Previewing a theme

You can preview the installed theme without logging out:
```sh
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme/
```

To preview this checkout directly, run from the repository root:
```sh
nix develop --command env QT_QPA_PLATFORM=wayland sddm-greeter-qt6 --test-mode --theme "$PWD"
```

Note that depending on the system configuration, the preview may differ slightly from the actual login screen.

## Sources

Initially the theme was independed fork of [MarianArlt's theme](https://github.com/MarianArlt/sddm-sugar-dark) but now the project has come a long way and started to significantly deviate from the original.
Many of the wallpapers and fonts used in this project are very popular and copied from one user to another, so I don't know who the original creator is. 
I also redesigned many of them, but here are links to some of the orginal artists who created these wonderful wallpapers:

- Astronaut: [wallpaper](https://wallhaven.cc/w/e76pew), [font](https://fonts.google.com/specimen/Open+Sans/about)
- Black hole: [wallpaper](https://images2.alphacoders.com/114/1141632.jpg), [font](https://www.1001fonts.com/espacion-font.html)
- Japanese aesthetic: [wallpaper](https://imgur.com/a/pua0dYx) by [gharly](https://www.artstation.com/gharly), [font](https://www.1001fonts.com/electroharmonix-font.html)
- Purple leaves: [wallpaper](https://wallha.com/wallpaper/artwork-abstract-leaves-purple-texture-pattern-1414432), [font](https://fonts.google.com/specimen/Open+Sans/about)
- Cyberpunk: [wallpaper](https://images5.alphacoders.com/133/1330479.png) by [patrika](https://alphacoders.com/users/profile/227699/patrika), [font](https://www.1001fonts.com/kognigear-font.html)
- Post-apocalyptic hacker:  [wallpaper](https://images.alphacoders.com/137/thumb-1920-1375178.png) by [patrika](https://alphacoders.com/users/profile/227699/patrika), [font](https://www.1001fonts.com/fragile-bombers-font.html)
- Hyprland Kath: original [wallpaper](https://motionbgs.com/andvari-last-origin), [font](https://www.1001fonts.com/pixelon-font.html); this fork uses a custom `hyprland_kath_mocha.mp4` background.
- Pixel sakura: [wallpaper](https://imgur.com/gallery/sakura-tree-with-petals-flying-off-t5tg4N8), [font](https://www.1001fonts.com/arcadeclassic-font.html)
- Jake the dog: [wallpaper](https://motionbgs.com/jake-the-dog), [font](https://fontmeme.com/fonts/thunderman-font/)
  
## Supporting project

You can support the original author by dropping a **star** on **[github](https://github.com/Keyitdev/sddm-astronaut-theme)** or giving a **subscription** on **[YouTube](http://www.youtube.com/channel/UCVoGVyAP2sHPQyegwBMJKyQ?sub_confirmation=1)**.

If you enjoyed the theme and would like to show your appreciation, you can make a **[donation](https://ko-fi.com/keyitdev)** using **[kofi](https://ko-fi.com/keyitdev)**.

[![Ko-fi](https://img.shields.io/badge/support_me_on_ko--fi-F16061?style=for-the-badge&logo=kofi&logoColor=f5f5f5)](https://ko-fi.com/keyitdev)

Distributed under the **[GPLv3+](https://www.gnu.org/licenses/gpl-3.0.html) License**.    
Copyright (C) 2022-2025 Keyitdev.

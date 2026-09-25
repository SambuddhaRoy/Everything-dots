# Everything-dots

Hyprland, riced around a single morphing pill: a Nothing OS–style Quickshell
shell with dot-matrix type, black glass, and one small spark of colour.

> *Quiet, precise hardware: black glass, white dot-matrix light, and one small
> spark of colour. Nothing on screen that doesn't need to be there.*
> — [INTENT.md](config/quickshell/nothing/INTENT.md)

## Install (Arch Linux and derivatives)

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/SambuddhaRoy/Everything-dots/main/install.sh)
```

This installs packages (official repos first, AUR as a fallback), fonts, and a
default wallpaper; symlinks the configs into `~/.config`, backing up anything
it replaces to `~/.config/everything-dots-backup/`; generates the theme; and
sets up auto-updates. Then log into the Hyprland session.

Options: `--yes` (don't ask), `--no-packages`, `--no-autoupdate`, `--link-only`.

### Updates

A systemd user timer (`everything-dots-update.timer`, every 6 h and 10 min
after boot) fast-forwards `~/Everything-dots`, re-links, reloads Hyprland and
restarts the shell. It won't overwrite local edits, and it won't restart
while the screen is locked. Run it by hand with `~/Everything-dots/update.sh`.

Your own settings are never in the repo, so updates don't touch them:
`config.json` (shell settings), `keybinds.json` (edited binds),
`hyprland.json` (Hyprland overrides), plus the generated colour/shape files.

## What's in it

**The pill.** One island at the top that grows into whatever you open:
- **Resting:** workspace dots, a dot-matrix clock, an animated dot weather glyph, a live audio waveform while music plays, the tray, Wi-Fi/Bluetooth, and a battery.
- **Views:**
  - launcher (instant, with calculator, qalculate `=`, commands `>` and web search)
  - quick settings with Nothing-style tiles and pill sliders
  - calendar
  - weather (Open-Meteo, hourly and 7-day)
  - media (cover-art tinted, dot waveform, seekable dot progress)
  - capture (screenshots and recording)
  - Wi-Fi, Bluetooth, wallpaper, power, tray menus, polkit, notifications, OSD

**Lock screen.** A dot-matrix clock, serif date, glass cards and PAM login,
scaled to any resolution; hyprlock is the fallback.

**Desktop widgets.** Clock, weather, now playing, calendar, a battery ring
(chasing dots while charging), dot-bar system meters and a sticky note. All
draggable.

**Settings** (`Super+I`). Appearance, pill, widgets, Wallhaven browser,
windows, input, display (with auto-revert), sound (devices and per-app),
network, power & lock, weather, notifications, a full **keybind editor**
(shows what every bind does; rebind to apps, commands or actions), and about.

**Theme.**
- Colours come from the wallpaper with matugen. You pick which wallpaper colour leads, and neutral surfaces are on by default.
- Or pick your own base, surface and accent, or let the cover art of what's playing lead.
- Shape: one corner radius and one gap everywhere, or **brutalist** mode (no rounded corners at all, square dots).
- Bloom on dot-matrix elements, and unfocused windows turn to frosted glass instead of drawing borders.

## Keys

| Keys | |
|---|---|
| `Super` (tap) | launcher |
| `Super+I` | settings |
| `Super+N` · `Super+M` · `Super+A` | quick settings · media · calendar |
| `Super+Print` | capture panel |
| `Super+Shift+S` | screenshot an area (saved and copied) |
| `Super+Shift+R` | record an area (again to stop) |
| `Ctrl+Super+T` | wallpapers |
| `Super+L` | lock |
| `Ctrl+Alt+Delete` | power menu |

Everything else: Settings › Keybinds.

## Layout

```
config/hypr/                 Hyprland (Lua config)
config/quickshell/nothing/   the shell (see its README)
install.sh  update.sh
```

## Credits

- Keybinds and helper scripts derive from
  [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) (GPL-3.0),
  so this repo is GPL-3.0 too.
- Built with [Quickshell](https://quickshell.org) and
  [matugen](https://github.com/InioX/matugen).
- Fonts: Instrument Serif and Space Mono (SIL OFL, fetched from google/fonts).
- Weather by [Open-Meteo](https://open-meteo.com), locating by
  [wttr.in](https://wttr.in); wallpapers from [Wallhaven](https://wallhaven.cc).
- Inspired by Nothing OS.

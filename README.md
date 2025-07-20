# proto-navi v0.1.0beta-stable

Universal file browser with intelligent previews and global keybindings that work on any file type.

## Features

- **Universal File Browsing** - Navigate any directory with fuzzy finding
- **Intelligent Previews** - Syntax highlighting, image preview, video metadata, PDF text extraction
- **Global Keybindings** - Consistent shortcuts that work across all file types  
- **Interactive Application Menus** - Choose from multiple browsers, image viewers, and media players
- **Terminal-Based** - Fast, lightweight, works over SSH
- **Cross-Platform** - Supports macOS and Linux
- **Extensible Architecture** - Modular design with external application selector

## Keybindings

### File Operations
- **ctrl+o**: Open with default application
- **ctrl+p**: QuickLook preview (macOS)
- **ctrl+d**: Show in Finder/file manager

### Application Menus
- **ctrl+b**: Browser selection menu  
  - [s] Safari  
  - [g] Google Chrome  
  - [f] Firefox  
  - [c] Chromium  
  - [q] Qutebrowser  
  - [v] Vieb
- **ctrl+i**: Image viewer selection menu  
  - [p] Preview (macOS)  
  - [x] Pixelmator Pro  
  - [g] GIMP  
  - [a] Affinity Photo  
  - [f] feh  
  - [e] Eye of GNOME  
  - [k] Gwenview  
  - [s] sxiv
- **ctrl+m**: Media player selection menu  
  - [q] QuickTime Player  
  - [v] VLC  
  - [i] IINA  
  - [m] mpv  
  - [p] mplayer  
  - [t] Totem  
  - [c] Celluloid

### Text Editors
- **ctrl+v**: Open in Vim
- **ctrl+n**: Open in Nano
- **ctrl+e**: Open in Emacs

### Special
- **ctrl+g**: Glow (beautiful markdown rendering)
- **ctrl+j/k**: Navigate down/up
- **ctrl+q**: Quit

## Preview Capabilities

Proto-navi intelligently previews various file types:

- **Code Files** - Syntax highlighted for Python, JavaScript, Go, Rust, etc.
- **Markdown** - Rendered with glow
- **JSON/YAML** - Formatted with jq and bat
- **Images** - Terminal display (PNG, JPG, SVG, etc.)
- **Videos** - Display metadata with ffprobe
- **Audio** - Display metadata with exiftool
- **PDFs** - Text extraction preview
- **CSV** - Tabular preview

All file extensions are handled case-insensitively.

## Coming Soon

### Planned Features

Check the `coming_soon/planned_features.md` for more details.

## Architecture

Proto-navi consists of two components:

1. **proto-navi** - Main file browser with preview engine
2. **app_selector** - Application selection menu system

Both install to `/usr/local/bin/` and work together seamlessly.

## Installation

### Quick Install

```bash
sudo ./install.sh
```

### Manual Installation

```bash
# Copy scripts
sudo cp proto-navi.sh /usr/local/bin/proto-navi
sudo cp app_selector.sh /usr/local/bin/app_selector
sudo chmod +x /usr/local/bin/proto-navi /usr/local/bin/app_selector

# Install man page
sudo cp proto-navi.1 /usr/local/share/man/man1/
sudo chmod 644 /usr/local/share/man/man1/proto-navi.1
```

## Dependencies

### Required
- **fzf** - Fuzzy finder
- **find** - File discovery (standard on Unix systems)

### Optional (Enhanced Previews)
- **bat** - Syntax highlighting
- **glow** - Markdown rendering  
- **jq** - JSON formatting
- **pdftotext** - PDF text extraction
- **viu/chafa/catimg** - Image preview
- **ffprobe** - Video metadata
- **exiftool** - Audio metadata

### Install Dependencies

**macOS:**
```bash
brew install fzf bat glow jq poppler viu chafa ffmpeg exiftool
```

**Ubuntu/Debian:**
```bash
sudo apt install fzf bat glow jq poppler-utils chafa ffmpeg exiftool
```

**Fedora/RHEL:**
```bash
sudo dnf install fzf bat glow jq poppler-utils chafa ffmpeg perl-Image-ExifTool
```

## Usage

Start the file browser:
```bash
proto-navi
```

### Tips

- Add an alias for quick access: `alias nav="proto-navi"`
- Works great over SSH for remote file browsing
- Handles large directories efficiently with fzf's fuzzy matching
- Preview pane updates in real-time as you navigate
- Use the menu letters (shown in brackets) for quick selection

## Documentation

View the complete manual:
```bash
man proto-navi
```

## License

GPL v3 - See LICENSE file for details.

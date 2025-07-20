#!/bin/bash

# Universal application selector - works everywhere the same way
# Now with better error handling and user feedback

select_app() {
    local type="$1"
    local file="$2"
    local choice
    
    # Debug: Show what we received
    echo "Opening $type app for file: $file"
    
    # Check if file exists
    if [[ ! -f "$file" ]]; then
        echo "Error: File '$file' not found"
        read -p "Press Enter to continue..."
        return 1
    fi
    
    case "$type" in
        "image")
            choice=$(echo -e "Preview\nPixelmator Pro\nGIMP\nAffinity Photo\nfeh\nEye of GNOME\nGwenview\nsxiv\nviewer" | fzf --prompt="Image App > " --height=12 --border)
            if [[ -n "$choice" ]]; then
                echo "Opening $file with $choice..."
                case "$choice" in
                    "Preview") 
                        if open -a Preview "$file" 2>/dev/null; then
                            echo "✓ Opened with Preview"
                        else
                            echo "✗ Preview not available"
                        fi ;;
                    "Pixelmator Pro") 
                        if open -a "Pixelmator Pro" "$file" 2>/dev/null; then
                            echo "✓ Opened with Pixelmator Pro"
                        else
                            echo "✗ Pixelmator Pro not available"
                        fi ;;
                    "GIMP") 
                        if gimp "$file" 2>/dev/null & then
                            echo "✓ Opened with GIMP"
                        else
                            echo "✗ GIMP not available"
                        fi ;;
                    "Affinity Photo") 
                        if open -a "Affinity Photo" "$file" 2>/dev/null; then
                            echo "✓ Opened with Affinity Photo"
                        else
                            echo "✗ Affinity Photo not available"
                        fi ;;
                    "feh") 
                        if /opt/homebrew/bin/feh --auto-zoom --borderless "$file" 2>/dev/null & then
                            echo "✓ Opened with feh"
                        elif feh --auto-zoom --borderless "$file" 2>/dev/null & then
                            echo "✓ Opened with feh"
                        else
                            echo "✗ feh not available"
                        fi ;;
                    "Eye of GNOME") 
                        if eog "$file" 2>/dev/null & then
                            echo "✓ Opened with Eye of GNOME"
                        else
                            echo "✗ Eye of GNOME not available"
                        fi ;;
                    "Gwenview") 
                        if gwenview "$file" 2>/dev/null & then
                            echo "✓ Opened with Gwenview"
                        else
                            echo "✗ Gwenview not available"
                        fi ;;
                    "sxiv") 
                        if sxiv "$file" 2>/dev/null & then
                            echo "✓ Opened with sxiv"
                        else
                            echo "✗ sxiv not available"
                        fi ;;
                    "viewer") 
                        if viewer "$file" 2>/dev/null & then
                            echo "✓ Opened with viewer"
                        else
                            echo "✗ viewer not available"
                        fi ;;
                esac
                read -p "Press Enter to continue..."
            else
                echo "No app selected"
            fi
            ;;
        "video")
            choice=$(echo -e "QuickTime Player\nVLC\nIINA\nmpv\nmplayer\nTotem\nCelluloid" | fzf --prompt="Video App > " --height=10 --border)
            if [[ -n "$choice" ]]; then
                echo "Opening $file with $choice..."
                case "$choice" in
                    "QuickTime Player") 
                        if open -a "QuickTime Player" "$file" 2>/dev/null; then
                            echo "✓ Opened with QuickTime Player"
                        else
                            echo "✗ QuickTime Player not available"
                        fi ;;
                    "VLC") 
                        if open -a VLC "$file" 2>/dev/null; then
                            echo "✓ Opened with VLC"
                        elif vlc "$file" 2>/dev/null & then
                            echo "✓ Opened with VLC (command line)"
                        else
                            echo "✗ VLC not available"
                        fi ;;
                    "IINA") 
                        if open -a IINA "$file" 2>/dev/null; then
                            echo "✓ Opened with IINA"
                        else
                            echo "✗ IINA not available"
                        fi ;;
                    "mpv") 
                        if /opt/homebrew/bin/mpv "$file" 2>/dev/null & then
                            echo "✓ Opened with mpv"
                        elif mpv "$file" 2>/dev/null & then
                            echo "✓ Opened with mpv"
                        else
                            echo "✗ mpv not available"
                        fi ;;
                    "mplayer") 
                        if mplayer "$file" 2>/dev/null & then
                            echo "✓ Opened with mplayer"
                        else
                            echo "✗ mplayer not available"
                        fi ;;
                    "Totem") 
                        if totem "$file" 2>/dev/null & then
                            echo "✓ Opened with Totem"
                        else
                            echo "✗ Totem not available"
                        fi ;;
                    "Celluloid") 
                        if celluloid "$file" 2>/dev/null & then
                            echo "✓ Opened with Celluloid"
                        else
                            echo "✗ Celluloid not available"
                        fi ;;
                esac
                read -p "Press Enter to continue..."
            else
                echo "No app selected"
            fi
            ;;
        "browser")
            choice=$(echo -e "Safari\nGoogle Chrome\nFirefox\nChromium\nQutebrowser\nVieb" | fzf --prompt="Browser > " --height=8 --border)
            case "$choice" in
                "Safari") open -a Safari "$file" 2>/dev/null || echo "Safari not available" ;;
                "Google Chrome") (open -a "Google Chrome" "$file" 2>/dev/null || google-chrome "$file" 2>/dev/null) || echo "Chrome not available" ;;
                "Firefox") (open -a Firefox "$file" 2>/dev/null || firefox "$file" 2>/dev/null) || echo "Firefox not available" ;;
                "Chromium") chromium "$file" 2>/dev/null || echo "Chromium not available" ;;
                "Qutebrowser") qutebrowser "$file" 2>/dev/null || echo "Qutebrowser not available" ;;
                "Vieb") vieb "$file" 2>/dev/null || echo "Vieb not available" ;;
            esac
            ;;
    esac
}

select_app "$1" "$2"

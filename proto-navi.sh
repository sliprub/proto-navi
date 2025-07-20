#!/bin/bash

# Universal file browser with global keybindings that work on any file type
# Multi-key sequences like Emacs

find "$PWD" -type f 2>/dev/null | fzf --preview '
  file={}
  shopt -s nocasematch
  case {} in
    # Markdown files
    *.md|*.markdown) 
      if command -v glow > /dev/null 2>&1; then
        bat --color=always --style=plain --language=markdown {} 
      else
        bat --color=always --language=markdown {} 
      fi
      ;;
    
    # Code files
    *.py|*.sh|*.js|*.jsx|*.ts|*.tsx|*.html|*.css|*.c|*.cpp|*.h|*.hpp|*.java|*.rs|*.go|*.rb|*.php)
      bat --color=always {}
      ;;
    
    # Data files
    *.json)
      jq . {} 2>/dev/null | bat --language=json --color=always 2>/dev/null || cat {}
      ;;
    *.yml|*.yaml)
      bat --color=always {}
      ;;
    *.csv)
      head -n 20 {}
      ;;
    *.xml)
      bat --color=always --language=xml {}
      ;;

    # PDF files
    *.pdf|*.PDF) 
      if command -v pdftotext > /dev/null 2>&1; then
        pdftotext -layout -f 1 -l 3 {} - 2>/dev/null | head -n 100
      else
        echo "📄 PDF file"
        file {}
      fi
      ;;
    
    # Image files
    *.svg|*.png|*.jpg|*.jpeg|*.gif|*.bmp|*.webp|*.PNG|*.JPG|*.JPEG|*.GIF|*.BMP|*.WEBP|*.SVG)
      if command -v viu > /dev/null 2>&1; then
        viu -w 100 {}
      elif command -v chafa > /dev/null 2>&1; then
        chafa -s 80x40 {}
      elif command -v catimg > /dev/null 2>&1; then
        catimg -w 80 {}
      else
        echo "📷 Image file"
        file {}
      fi
      ;;
    
    # Video files
    *.mp4|*.mov|*.mkv|*.avi|*.webm|*.flv|*.wmv|*.MP4|*.MOV|*.MKV|*.AVI|*.WEBM|*.FLV|*.WMV) 
      if command -v ffprobe > /dev/null 2>&1; then
        ffprobe -v error -select_streams v:0 -show_entries stream=width,height,duration,codec_name -of default=noprint_wrappers=1 {} 2>/dev/null
      else
        echo "🎥 Video file"
        file {}
      fi
      ;;
    
    # Audio files
    *.mp3|*.wav|*.flac|*.aac|*.ogg|*.m4a|*.MP3|*.WAV|*.FLAC|*.AAC|*.OGG|*.M4A)
      if command -v exiftool > /dev/null 2>&1; then
        exiftool {} 2>/dev/null | grep -E "Duration|Artist|Title|Album|Bit Rate" 
      else
        echo "🎵 Audio file"
        file {}
      fi
      ;;
    
    # Default case
    *) 
      file {}
      ;;
  esac
  
  echo ""
  echo "UNIVERSAL KEYBINDINGS (work on any file):"
  echo "ctrl-o: Default app  | ctrl-p: QuickLook preview"
  echo "ctrl-b: Browsers     | ctrl-i: Image viewers  | ctrl-m: Media players"
  echo "ctrl-v: Vim          | ctrl-n: Nano          | ctrl-e: Emacs"
  echo "ctrl-g: Glow         | ctrl-d: Show in Finder"
  echo "ctrl-j: Down         | ctrl-k: Up            | ctrl-q: Quit"
' \
  --bind "ctrl-o:execute(open {} &>/dev/null &)" \
  --bind "ctrl-p:execute(qlmanage -p {} &>/dev/null &)" \
  --bind "ctrl-b:execute(/usr/local/bin/app_selector browser {} < /dev/tty)" \
  --bind "ctrl-i:execute(/usr/local/bin/app_selector image {} < /dev/tty)" \
  --bind "ctrl-m:execute(/usr/local/bin/app_selector video {} < /dev/tty)" \
  --bind "ctrl-v:execute(vim {} < /dev/tty)" \
  --bind "ctrl-n:execute(nano {} < /dev/tty)" \
  --bind "ctrl-e:execute(emacs {} < /dev/tty)" \
  --bind "ctrl-g:execute(glow -s dark -p {})" \
  --bind "ctrl-d:execute(open -R {} &>/dev/null &)" \
  --bind "ctrl-j:down" \
  --bind "ctrl-k:up" \
  --bind "ctrl-q:abort"

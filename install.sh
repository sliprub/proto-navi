#!/bin/bash

# proto-navi Installation Script
# Universal file browser with intelligent previews

set -e

echo "🚀 Installing proto-navi"
echo "========================"
echo

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root (use sudo)"
   exit 1
fi

# Check required files
if [[ ! -f "proto-navi.sh" ]] || [[ ! -f "app_selector.sh" ]]; then
    print_error "Required files not found. Run this script from the proto-navi directory."
    exit 1
fi

print_success "Found required files"

# Check dependencies
echo "Checking dependencies..."
missing_deps=()

if ! command -v fzf &> /dev/null; then
    missing_deps+=("fzf")
fi

if ! command -v find &> /dev/null; then
    missing_deps+=("find")
fi

if [ ${#missing_deps[@]} -gt 0 ]; then
    print_error "Missing required dependencies: ${missing_deps[*]}"
    echo
    echo "Install them first:"
    echo "  macOS: brew install ${missing_deps[*]}"
    echo "  Ubuntu/Debian: sudo apt install ${missing_deps[*]}"
    echo "  Fedora/RHEL: sudo dnf install ${missing_deps[*]}"
    exit 1
fi

print_success "Required dependencies found"

# Check optional dependencies
optional_deps=("bat" "glow" "jq" "pdftotext" "viu" "chafa" "ffprobe" "exiftool")
missing_optional=()

for dep in "${optional_deps[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
        missing_optional+=("$dep")
    fi
done

if [ ${#missing_optional[@]} -gt 0 ]; then
    print_warning "Optional dependencies missing: ${missing_optional[*]}"
    echo "  Install for enhanced previews, but proto-navi will work without them"
else
    print_success "All optional dependencies found"
fi

echo

# Install files
echo "Installing proto-navi..."

# Create directories
mkdir -p /usr/local/bin
mkdir -p /usr/local/share/man/man1

# Install main scripts
cp proto-navi.sh /usr/local/bin/proto-navi
cp app_selector.sh /usr/local/bin/app_selector
chmod +x /usr/local/bin/proto-navi /usr/local/bin/app_selector

print_success "Scripts installed to /usr/local/bin/"

# Install man page
if [[ -f "proto-navi.1" ]]; then
    cp proto-navi.1 /usr/local/share/man/man1/
    chmod 644 /usr/local/share/man/man1/proto-navi.1
    print_success "Man page installed"
fi

# Verify installation
if [[ -x "/usr/local/bin/proto-navi" ]] && [[ -x "/usr/local/bin/app_selector" ]]; then
    print_success "Installation verified!"
else
    print_error "Installation verification failed"
    exit 1
fi

echo
echo "🎉 proto-navi installation complete!"
echo

# Interactive alias setup
setup_alias() {
    echo "${YELLOW}📝 Alias Setup${NC}"
    echo "========================"
    echo "Choose an alias for easy proto-navi access:"
    echo
    echo "  1) n4vi     - leet-ish shortcut"
    echo "  2) navi     - easy to remember"
    echo "  3) pn       - proto-navi abbreviation"
    echo "  4) nav      - navigation shortcut"
    echo "  5) nani?    - what? 何 (anime reference)"
    echo "  6) Skip     - Don't create an alias"
    echo
    echo -n "Enter your choice (1-6): "
    read -r choice
    
    local alias_name=""
    case $choice in
        1) alias_name="n4vi" ;;
        2) alias_name="navi" ;;
        3) alias_name="pn" ;;
        4) alias_name="nav" ;;
        5) alias_name="nani?" ;;
        6) 
            print_success "Skipping alias creation."
            print_success "You can run: proto-navi"
            return
            ;;
        *) 
            print_warning "Invalid choice. Skipping alias creation."
            return
            ;;
    esac
    
    # Detect shell and create appropriate alias
    local shell_rc=""
    local shell_name
    
    # Handle sudo situation
    if [ -n "$SUDO_USER" ]; then
        if command -v dscl &>/dev/null; then
            # macOS
            USER_SHELL=$(dscl . -read /Users/"$SUDO_USER" UserShell | awk '{print $2}')
            USER_HOME=$(dscl . -read /Users/"$SUDO_USER" NFSHomeDirectory | awk '{print $2}')
        else
            # Linux
            USER_SHELL=$(getent passwd "$SUDO_USER" | cut -d: -f7)
            USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
        fi
        shell_name=$(basename "$USER_SHELL")
        HOME_DIR="$USER_HOME"
    else
        shell_name=$(basename "$SHELL")
        HOME_DIR="$HOME"
    fi
    
    if [[ "$shell_name" == "zsh" ]]; then
        shell_rc="$HOME_DIR/.zshrc"
    elif [[ "$shell_name" == "bash" ]]; then
        shell_rc="$HOME_DIR/.bashrc"
        if [[ ! -f "$shell_rc" && -f "$HOME_DIR/.bash_profile" ]]; then
            shell_rc="$HOME_DIR/.bash_profile"
        fi
    else
        print_warning "Unknown shell ($shell_name). Add manually:"
        echo "alias '$alias_name'='proto-navi'"
        return
    fi
    
    # Add alias to shell config (quote alias name for special characters)
    local alias_line="alias '$alias_name'='proto-navi'"
    
    if grep -q "alias $alias_name=" "$shell_rc" 2>/dev/null; then
        print_warning "Alias '$alias_name' already exists in $shell_rc"
    else
        echo "" >> "$shell_rc"
        echo "# proto-navi alias" >> "$shell_rc"
        echo "$alias_line" >> "$shell_rc"
        print_success "Added alias '$alias_name' to $shell_rc"
        print_success "Restart terminal or run: source $shell_rc"
        print_success "Then use: $alias_name"
    fi
}

# Run alias setup
setup_alias

echo
echo "Usage:"
echo "  proto-navi              # Start file browser"
echo
echo "View the manual:"
echo "  man proto-navi"
echo
echo "Key bindings:"
echo "  ctrl+o: Open file        ctrl+p: Preview"
echo "  ctrl+b: Browsers         ctrl+i: Image viewers" 
echo "  ctrl+m: Media players    ctrl+g: Glow (markdown)"
echo "  ctrl+v: Vim              ctrl+q: Quit"
echo

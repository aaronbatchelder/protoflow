#!/bin/bash

# ProtoFlow Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/aaronbatchelder/protoflow/main/install.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}Installing ProtoFlow...${NC}"
echo ""

# Check for required dependencies
if ! command -v git &> /dev/null; then
  echo -e "${RED}Error: git is required but not installed${NC}"
  echo "Install git first: https://git-scm.com/downloads"
  exit 1
fi

if ! command -v claude &> /dev/null; then
  echo -e "${YELLOW}Warning: Claude Code CLI not found${NC}"
  echo "ProtoFlow requires Claude Code. Install it with:"
  echo "  npm install -g @anthropic-ai/claude-code"
  echo ""
fi

# Determine install location
INSTALL_DIR="$HOME/.protoflow"
BIN_DIR="/usr/local/bin"

# Check if we can write to /usr/local/bin, otherwise use ~/.local/bin
if [[ ! -w "$BIN_DIR" ]] && [[ ! -w "$(dirname "$BIN_DIR")" ]]; then
  BIN_DIR="$HOME/.local/bin"
  mkdir -p "$BIN_DIR"

  # Check if ~/.local/bin is in PATH
  if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "${YELLOW}Note: $BIN_DIR is not in your PATH${NC}"
    echo "Add this to your shell profile (.bashrc, .zshrc, etc.):"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
  fi
fi

# Remove old installation if exists
if [[ -d "$INSTALL_DIR/repo" ]]; then
  echo -e "${CYAN}Removing old installation...${NC}"
  rm -rf "$INSTALL_DIR/repo"
fi

# Clone the repo
echo -e "${CYAN}Downloading ProtoFlow...${NC}"
mkdir -p "$INSTALL_DIR"
git clone --quiet https://github.com/aaronbatchelder/protoflow.git "$INSTALL_DIR/repo"

# Make executable
chmod +x "$INSTALL_DIR/repo/protoflow"

# Create symlink (remove old one first)
if [[ -L "$BIN_DIR/protoflow" ]] || [[ -f "$BIN_DIR/protoflow" ]]; then
  rm -f "$BIN_DIR/protoflow"
fi

# Try to create symlink, use sudo if needed
if [[ -w "$BIN_DIR" ]]; then
  ln -s "$INSTALL_DIR/repo/protoflow" "$BIN_DIR/protoflow"
else
  echo -e "${YELLOW}Need sudo to install to $BIN_DIR${NC}"
  sudo ln -s "$INSTALL_DIR/repo/protoflow" "$BIN_DIR/protoflow"
fi

echo ""
echo -e "${GREEN}✓ ProtoFlow installed successfully!${NC}"
echo ""
echo -e "  Run ${CYAN}protoflow${NC} in any git repo to get started."
echo ""
echo -e "  ${CYAN}Example:${NC}"
echo -e "    cd ~/projects/myapp"
echo -e "    protoflow"
echo ""

#!/bin/sh

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew install stow

# Remove any pre-existing real ~/.zshrc and ~/.gitconfig so stow can symlink them.
# Back up first (only if they exist and aren't already symlinks) to avoid silent data loss.
for f in "$HOME/.zshrc" "$HOME/.gitconfig"; do
  if [ -f "$f" ] && [ ! -L "$f" ]; then
    echo "Backing up existing $f -> $f.bak"
    mv "$f" "$f.bak"
  else
    rm -f "$f"
  fi
done
# ln -sw $HOME/.dotfiles/.zshrc $HOME/.zshrc <- replaced by stow a bit further down

# Add stow to instantiate all symlinks - uses .stow-local-ignore to filter out files and folders
# Specifically placed BEFORE installing anything via brew to avoid conflicts when symlinking
stow -vR --target="$HOME" */

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew bundle --file ./Brewfile

# Create project directories (lowercase to match the includeIf in git/.gitconfig)
mkdir -p "$HOME/personal"
mkdir -p "$HOME/work"

# Clone Github repositories
./clone.sh

# Set macOS preferences - we will run this last because this will reload the shell
source ./.macos

# (optional) restow if any packages wrote defaults
stow -vR --target="$HOME" */

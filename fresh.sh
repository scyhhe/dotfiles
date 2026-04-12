#!/bin/sh

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo '$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>$HOME/.zprofile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
# ln -sw $HOME/.dotfiles/.zshrc $HOME/.zshrc <- replaced by stow a bit further down

# Add stow to instantiate all symlinks - uses .stow-local-ignore to filter out files and folders
# Specifically placed BEFORE existsalling anything via brew to avoid conflicts when symlinking
stow -vR --target="$HOME" claude ghostty git nvim zed zsh

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew bundle --file ./Brewfile

# Create a projects directories
mkdir $HOME/Personal
mkdir $HOME/Work

# Clone Github repositories
./clone.sh

# (optional) restow if any packages wrote defaults
stow -vR --target="$HOME" claude ghostty git nvim zed zsh

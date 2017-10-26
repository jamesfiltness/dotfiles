#!/usr/bin/env bash

# Get the directory in which this script is executing
cd "$(dirname "$0")"
SCRIPT_ROOT=$(pwd -P)

# Prompt for the admin password
sudo -v

echo "Setting up..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install software via Homebrew
${SCRIPT_ROOT}/install-software

# Set homebrew zsh as the default shell
sudo -s 'echo /usr/local/bin/zsh >> /etc/shells' && chsh -s /usr/local/bin/zsh

# Install om-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Make a dev directory
mkdir dev

# Copy dotfiles to home directory
cp -r ${SCRIPT_ROOT}/_dotfiles/. ~/

# Set up vim and install plugins
vim +PluginInstall +qall

# Set up osx preferences
sudo ${SRIPT_ROOT}/osx-setup

# Take some inspiration from this repo...
# https://github.com/driesvints/dotfiles/tree/7cb1ea6eff77921d16a3376a2172f96425e93181

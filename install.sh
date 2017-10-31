#!/usr/bin/env bash

# Exit immediately on error
set -e

# Prompt for admin password
sudo -v

function link_file() {
  SRC=$1
  DEST=$2

  if [ -f $DEST ]; then
    mv "$DEST" "${DEST}.backup"
  fi

  if ! [ -L $DEST ]; then
    ln -ivs $SRC $DEST
  else
    echo "Skipping, link already exists: $DEST"
  fi
}

# Symlink dotfiles in to ~
function install_dotfiles () {
  echo 'Symlinking dotfiles'

  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}

# Create a dev directory in ~
echo 'Create a dev directory'
if [ ! -d ~/dev ] ; then
  mkdir ~/dev
fi

# Get the directory this script is running in
cd "$(dirname "$0")"
export DOTFILES_ROOT=$(pwd -P)

# Install Homebrew
if test ! $(which brew)
then
  echo "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
fi

# Run Homebrew through the Brewfile
echo "Installing software via Homebrew"
brew bundle

# Add Homebrew Zsh to shells and switch to it.
sudo sh -c "echo "$(brew --prefix)/bin/zsh" >> /etc/shells"
sudo chsh -s "$(brew --prefix)/bin/zsh" $USER

# Symlink dotfiles in to ~
echo "Symlinking dotfiles"
install_dotfiles

# Copy necessary files across in to ~
echo "Copy files"
cp -r copy/home/. ~/

echo "Copying fonts"
cp -r copy/fonts/. ~/Library/fonts/

echo "Installing vundle"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install Vim plugins.
echo "Setup vim"
vim +PluginInstall +qall

# Configure preferences for OS X.
echo "Setting Mac OS X preferences"
sudo $DOTFILES_ROOT/macos/set-defaults.sh

# Install Oh My Zsh.
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

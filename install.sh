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

echo "Copying fonts"
cp -r copy/fonts/. $HOME/Library/fonts/

echo "Installing vundle"
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

# Install Vim plugins.
echo "Setup vim"
vim +PluginInstall +qall

# Configure preferences for OS X.
echo "Setting Mac OS X preferences"
sudo $DOTFILES_ROOT/macos/set-defaults.sh

# Install Oh My Zsh.
# Don't run the manual installer as it exits the install process and doesn't
# allow custom files to be copied in to .oh-my-zsh directory
echo "Installing oh-my-zsh"
git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

echo "Copying files in to ~"
cp -r copy/home/. $HOME/

echo "Copy iTerm color scheme to the desktop"
git clone https://github.com/rahulpatel/oceanic-material-iterm $HOME/Desktop/oceanic-material-iterm

echo "*** Don't forget to install iTerm colorscheme ***"

echo "*** INSTALLATION COMPLETE ***"

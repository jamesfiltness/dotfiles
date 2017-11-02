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
  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}

# Get the directory this script is running in
cd "$(dirname "$0")"
export DOTFILES_ROOT=$(pwd -P)

# Create a dev directory in ~
if [ ! -d $HOME/dev ] ; then
  echo 'Create a dev directory'
  mkdir $HOME/dev
fi

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

# Initialise the dotfiles directory as a git repo so changes can be tracked
git init --quiet
git remote add origin git@github.com:jamesfiltness/dotfiles.git

# Symlink dotfiles in to ~
echo "Symlinking dotfiles"
install_dotfiles

echo "Copying fonts"
cp -r fonts/. $HOME/Library/fonts/

echo "Installing vundle"
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

# Configure preferences for OS X.
echo "Setting Mac OS X preferences"
sudo $DOTFILES_ROOT/macos/set-defaults.sh

# Install Oh My Zsh.
# Don't run the manual installer as it exits the install process and doesn't
# allow custom files to be copied in to .oh-my-zsh directory
echo "Installing oh-my-zsh"
git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

# First drop some placeholder files in to specified locations
# and then symlink the actual files in
ZSH_THEMES_DIR = $HOME/.oh-my-zsh/custom/themes
VIM COLORS_DIR = $HOME/.vim/colors

touch $ZSH_THEMES_DIR/jfiltness.zsh-theme
touch $VIM_COLORS_DIR/jfiltness.vim

echo "Symlink files in to ~"
link_file $DOTFILES_ROOT/oh-my-zsh/jfiltness.zsh-theme $ZSH_THEMES_DIR/jfiltness.zsh-theme
link_file $DOTFILES_ROOT/vim/jfiltness.vim $VIM_COLORS_DIR/jfiltness.vim

# Install Vim plugins.
echo "Setup vim"
vim +PluginInstall +qall

echo "Copy iTerm color scheme to the desktop"
git clone https://github.com/rahulpatel/oceanic-material-iterm $HOME/Desktop/oceanic-material-iterm

echo "*** INSTALLATION COMPLETE - REBOOT! ***"

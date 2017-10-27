#!/usr/bin/env bash

# Prompt for the admin password
sudo -v

# is this ok?
mkdir ~/dev

# Get the directory this script is running in
cd "$(dirname "$0")/.."
export DOTFILES_ROOT=$(pwd -P)

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

link_file () {
  local src=$1 dst=$2

  # Backup any files t
  mv "$dst" "${dst}.backup"
  success "Moved $dst to ${dst}.backup"

  # Symlink new files in
  ln -s "$1" "$2"
  success "Linked $1 to $2"
}

# Symlink dotfiles in to ~
install_dotfiles () {
  info 'Installing dotfiles'

  for src in $(find -H "$SCRIPT_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}

install_dotfiles

info "Installing dependencies"
if source ${DOTFILES_ROOT}/bin/install | while read -r data; do info "$data"; done
  then
    success "Dependencies installed"
  else
    fail "Error installing dependencies"
  fi

success 'Installation complete!'

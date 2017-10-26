#!/usr/bin/env bash

# Install core utilities as those that ship with OS X are out of date.
brew install coreutils --with-default-names
brew install findutils --with-default-names
brew install gnu-sed --with-default-names
brew install wget --with-iri

# Install Zsh.
brew install zsh
brew install zsh-syntax-highlighting

# Install more recent versions of some OS X tools.
brew install vim --override-system-vi
brew install homebrew/dupes/grep --with-default-names
brew install homebrew/dupes/openssh

# More useful formulae.
brew install git
brew install nvm
brew install rbenv
brew install the_silver_searcher

brew cask install 1password
brew cask install dropbox
brew cask install vlc
brew cask install iterm2-nightly
brew cask install postman
brew cask install docker


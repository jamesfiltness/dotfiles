export ZSH=$HOME/.dotfiles

# Set macOS defaults
$ZSH/macos/set-defaults.sh

# Install homebrew - stderr to stdout -but why?
$ZSH/homebrew/install.sh 2>&1

# Run Homebrew through the Brewfile
echo "Installing software via Homebrew"
brew bundle

# find the installers and run them iteratively
find . -name install.sh | while read installer ; do sh -c "${installer}" ; done

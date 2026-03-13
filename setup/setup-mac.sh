#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=setup-common.sh
source "${SCRIPT_DIR}/setup-common.sh"

BREWFILE_PATH="${DOTFILES_ROOT}/os/mac/Brewfile"

echo "Setup macOS development environment"

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools"
  xcode-select --install
else
  echo "Xcode Command Line Tools already installed"
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed"
fi

echo "Updating Homebrew packages"
brew update
brew upgrade

echo "Installing packages from Brewfile"
brew bundle --file "${BREWFILE_PATH}"

echo "Setting default shell to zsh"
ZSH_PATH="$(command -v zsh)"
if [[ -z "${ZSH_PATH}" ]]; then
  echo "zsh not found, skipping default shell change"
elif [[ "${SHELL}" != "${ZSH_PATH}" ]]; then
  chsh -s "${ZSH_PATH}"
  echo "Default shell changed to zsh (re-login required)"
else
  echo "Default shell is already zsh"
fi

echo "Setting up mise"
mise -v
if ! rg -F 'eval "$(mise activate zsh)"' "${HOME}/.zshrc" >/dev/null 2>&1; then
  echo 'eval "$(mise activate zsh)"' >> "${HOME}/.zshrc"
fi

echo "Installing Node and Python with mise"
mise use -g node@22
mise use -g python@3.14

echo "Configure global git identity"
read -r -p "Git user name: " GIT_NAME
read -r -p "Git email: " GIT_EMAIL

git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"
git config --global core.editor "code --wait"

echo "Configure AWS credentials"
aws configure

CERT_PATH="${HOME}/ca_certs/ZscalerRootCertificate-2048-SHA256.pem"
if [[ -f "${CERT_PATH}" ]]; then
  echo "Adding certificate to macOS keychain"
  sudo security add-trusted-cert \
    -d \
    -r trustRoot \
    -k /Library/Keychains/System.keychain \
    "${CERT_PATH}"
else
  echo "Zscaler certificate not found, skipping"
fi

echo "Setup completed"

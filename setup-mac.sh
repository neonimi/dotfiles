#!/usr/bin/env bash
set -e

echo "===== Setup Mac Bash Development Environment ====="
# Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
else
  echo "Xcode Command Line Tools already installed"
fi

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed"
fi

echo "Updating brew..."
brew update
brew upgrade

echo "Installing packages from Brewfile..."
brew bundle --file ./Brewfile

# mise
echo "Setting up mise..."
echo "mise version:"
mise -v
if ! grep -q "mise activate bash" ~/.bash_profile 2>/dev/null; then
  echo 'eval "$(mise activate bash)"' >> ~/.bash_profile
fi

# Node
echo "Installing Node..."
mise use -g node@22
echo "Node version:"
node -v

# Git
echo "Setting git config..."
read -p "Git user name: " GIT_NAME
read -p "Git email: " GIT_EMAIL

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global core.editor "code --wait"

# AWS
echo "Configure AWS credentials..."
aws configure
# aws configure set aws_access_key_id <your_access_key>
# aws configure set aws_secret_access_key <your_secret_key>
# aws configure set region <your_region>
# aws configure set output <your_output>

# --- Zscaler certificate ---
echo "Setting Zscaler certificate (optional)"

CERT_PATH="$HOME/ca_certs/ZscalerRootCertificate-2048-SHA256.pem"

if [ -f "$CERT_PATH" ]; then
  echo "Adding certificate to macOS keychain..."
  sudo security add-trusted-cert \
    -d \
    -r trustRoot \
    -k /Library/Keychains/System.keychain \
    "$CERT_PATH"
else
  echo "Zscaler certificate not found, skipping"
fi

echo "Setup completed successfully! o(^-^)o"

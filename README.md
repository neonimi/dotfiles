# dotfiles

Cross-platform dotfiles repository for macOS and Windows setup.

## Directory layout

```text
dotfiles/
├─ setup/
│  ├─ setup-mac.sh
│  ├─ setup-windows.ps1
│  └─ setup-common.sh
├─ bash/
│  ├─ bashrc
│  ├─ bash_profile
│  └─ aliases
├─ zsh/
│  ├─ zshrc
│  └─ zprofile
├─ git/
├─ config/
├─ os/
├─ vscode/
└─ README.md
```

## macOS setup

```bash
bash setup/setup-mac.sh
```

### zsh dotfiles example

```bash
ln -sf "$PWD/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$PWD/zsh/zprofile" "$HOME/.zprofile"
ln -sf "$PWD/bash/aliases" "$HOME/.aliases"
```

## Windows setup

```powershell
powershell -ExecutionPolicy Bypass -File .\setup\setup-windows.ps1
```

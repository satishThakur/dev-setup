#!/usr/bin/env bash
set -e

# Load version pins
source "$(dirname "$0")/versions.env"

# Detect shell profile
detect_shell_profile() {
  if [[ -n "$ZSH_VERSION" || -n "$ZSH_NAME" ]]; then
    echo "$HOME/.zshrc"
  else
    echo "$HOME/.bashrc"
  fi
}

# Append once to shell profile
append_to_shell_profile() {
  local content="$1"
  local profile
  profile=$(detect_shell_profile)

  if ! grep -Fq "$content" "$profile"; then
    echo "Appending to $profile..."
    echo "$content" >> "$profile"
  fi
}

# Python: pyenv
install_pyenv() {
  if ! command -v pyenv &>/dev/null; then
    echo "Installing pyenv..."
    curl https://pyenv.run | bash
  else
    echo "pyenv already installed"
  fi

  append_to_shell_profile '
# Pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
fi
'
}

# Poetry
install_poetry() {
  if ! command -v poetry &>/dev/null; then
    echo "Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
  else
    echo "Poetry already installed"
  fi

  append_to_shell_profile 'export PATH="$HOME/.local/bin:$PATH"'
}

# uv
install_uv() {
  if ! command -v uv &>/dev/null; then
    echo "Installing uv..."
    curl -Ls https://astral.sh/uv/install.sh | bash
  else
    echo "uv already installed"
  fi

  append_to_shell_profile 'export PATH="$HOME/.local/bin:$PATH"'
}

# Rust
install_rust() {
  if ! command -v rustup &>/dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
  else
    echo "Rust already installed"
  fi

  echo "Installing Rust $RUST_VERSION..."
  rustup install "$RUST_VERSION"
  rustup default "$RUST_VERSION"

  append_to_shell_profile 'source "$HOME/.cargo/env"'
}

# Go
install_go() {
  if ! command -v go &>/dev/null || [[ "$(go version)" != *"go$GO_VERSION"* ]]; then
    echo "Installing Go $GO_VERSION..."
    curl -LO "https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "go$GO_VERSION.linux-amd64.tar.gz"
    rm "go$GO_VERSION.linux-amd64.tar.gz"
  else
    echo "Go $GO_VERSION already installed"
  fi

  append_to_shell_profile 'export PATH="/usr/local/go/bin:$PATH"'
}

# SDKMAN + Java, Scala, sbt, Gradle
install_sdkman_tools() {
  if [ ! -d "$HOME/.sdkman" ]; then
    echo "Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
  else
    echo "SDKMAN already installed"
    source "$HOME/.sdkman/bin/sdkman-init.sh"
  fi

  echo "Installing pinned SDKMAN tools..."

  sdk install java "$JAVA_VERSION"
  sdk default java "$JAVA_VERSION"

  sdk install scala "$SCALA_VERSION"
  sdk default scala "$SCALA_VERSION"

  sdk install sbt "$SBT_VERSION"
  sdk default sbt "$SBT_VERSION"

  sdk install gradle "$GRADLE_VERSION"
  sdk default gradle "$GRADLE_VERSION"

  append_to_shell_profile 'source "$HOME/.sdkman/bin/sdkman-init.sh"'
}

main() {
  echo "🚀 Starting dev setup..."
  install_pyenv
  install_poetry
  install_uv
  install_rust
  install_go
  install_sdkman_tools
  echo "✅ All done. Please run: source ~/.bashrc or source ~/.zshrc"
}

main "$@"


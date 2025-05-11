#!/usr/bin/env bash
set -e

source "$(dirname "$0")/versions.env"

# Make sure SDKMAN is initialized
if [ -d "$HOME/.sdkman" ]; then
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

update_rust() {
  CURRENT=$(rustc --version | awk '{print $2}')
  if [ "$CURRENT" != "$RUST_VERSION" ]; then
    echo "🔄 Updating Rust from $CURRENT → $RUST_VERSION"
    rustup install "$RUST_VERSION"
    rustup default "$RUST_VERSION"
  else
    echo "✅ Rust is up-to-date ($RUST_VERSION)"
  fi
}

update_go() {
  CURRENT=$(go version | awk '{print $3}' | sed 's/go//')
  if [ "$CURRENT" != "$GO_VERSION" ]; then
    echo "🔄 Updating Go from $CURRENT → $GO_VERSION"
    curl -LO "https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "go$GO_VERSION.linux-amd64.tar.gz"
    rm "go$GO_VERSION.linux-amd64.tar.gz"
  else
    echo "✅ Go is up-to-date ($GO_VERSION)"
  fi
}

update_sdk_tool() {
  TOOL=$1
  VAR_NAME=$2
  CMD=$3

  DESIRED_VERSION=${!VAR_NAME}

  if ! command -v "$CMD" &>/dev/null; then
    echo "🔧 Installing $TOOL $DESIRED_VERSION..."
    sdk install "$TOOL" "$DESIRED_VERSION"
    sdk default "$TOOL" "$DESIRED_VERSION"
    return
  fi

  if [ "$TOOL" = "java" ]; then
    CURRENT=$(sdk current java | grep -o "$TOOL[^ ]*")
  else
    CURRENT=$($CMD --version 2>&1 | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n 1)
  fi

  if [ "$CURRENT" != "$DESIRED_VERSION" ]; then
    echo "🔄 Updating $TOOL from ${CURRENT:-unknown} → $DESIRED_VERSION"
    sdk install "$TOOL" "$DESIRED_VERSION"
    sdk default "$TOOL" "$DESIRED_VERSION"
  else
    echo "✅ $TOOL is up-to-date ($DESIRED_VERSION)"
  fi
}

main() {
  echo "📦 Updating tools to match versions.env..."

  update_rust
  update_go

  update_sdk_tool java JAVA_VERSION java
  update_sdk_tool scala SCALA_VERSION scala
  update_sdk_tool sbt SBT_VERSION sbt
  update_sdk_tool gradle GRADLE_VERSION gradle

  echo "🎉 Update complete."
}

main "$@"


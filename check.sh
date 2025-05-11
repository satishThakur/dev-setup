#!/usr/bin/env bash
set -e

source "$(dirname "$0")/versions.env"

has_error=0

fail_with_details() {
  echo "❌ $1 does not match expected version"
  echo "   Expected: $2"
  echo "   Found: $3"
  has_error=1
}

pass() {
  echo "✅ $1"
}

echo "🔍 Verifying pinned tool versions..."

# Poetry
if poetry --version &>/dev/null; then
  pass "Poetry"
else
  fail_with_details "Poetry" "installed" "not found"
fi

# uv
if UV_VERSION=$(uv --version 2>/dev/null); then
  pass "uv"
else
  fail_with_details "uv" "installed" "not found"
fi

# Rust
if RUST_OUTPUT=$(rustc --version 2>/dev/null); then
  echo "$RUST_OUTPUT" | grep -q "$RUST_VERSION" || fail_with_details "Rust" "$RUST_VERSION" "$RUST_OUTPUT"
  pass "Rust"
else
  fail_with_details "Rust" "$RUST_VERSION" "not found"
fi

# Go
if GO_OUTPUT=$(go version 2>/dev/null); then
  echo "$GO_OUTPUT" | grep -q "go$GO_VERSION" || fail_with_details "Go" "go$GO_VERSION" "$GO_OUTPUT"
  pass "Go"
else
  fail_with_details "Go" "go$GO_VERSION" "not found"
fi

# Java
if JAVA_OUTPUT=$(java -version 2>&1); then
  echo "$JAVA_OUTPUT" | grep -q '"21' || fail_with_details "Java" "$JAVA_VERSION" "$JAVA_OUTPUT"
  pass "Java"
else
  fail_with_details "Java" "$JAVA_VERSION" "not found"
fi

# Scala
if SCALA_OUTPUT=$(scala -version 2>&1); then
  echo "$SCALA_OUTPUT" | grep -q "$SCALA_VERSION" || fail_with_details "Scala" "$SCALA_VERSION" "$SCALA_OUTPUT"
  pass "Scala"
else
  fail_with_details "Scala" "$SCALA_VERSION" "not found"
fi

# sbt
if SBT_OUTPUT=$(sbt -version 2>&1); then
  echo "$SBT_OUTPUT" | grep -q "$SBT_VERSION" || fail_with_details "sbt" "$SBT_VERSION" "$SBT_OUTPUT"
  pass "sbt"
else
  fail_with_details "sbt" "$SBT_VERSION" "not found"
fi

# Gradle
if GRADLE_OUTPUT=$(gradle --version 2>/dev/null); then
  echo "$GRADLE_OUTPUT" | grep -q "$GRADLE_VERSION" || fail_with_details "Gradle" "$GRADLE_VERSION" "$GRADLE_OUTPUT"
  pass "Gradle"
else
  fail_with_details "Gradle" "$GRADLE_VERSION" "not found"
fi

# Final status
if [ "$has_error" -eq 0 ]; then
  echo "🎉 All tools match pinned versions!"
else
  echo "❌ One or more tools did not match expected versions."
  exit 1
fi


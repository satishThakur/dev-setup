# Dev Setup

A reproducible, version-pinned development environment bootstrap for Linux systems (tested on Pop!_OS and Ubuntu).

This repository installs and manages:

- **Python** (via `pyenv`)
- **Poetry** (Python dependency manager)
- **uv** (ultrafast Python package manager)
- **Rust** (via `rustup`)
- **Go** (from official tarball)
- **Java**, **Scala**, **sbt**, **Gradle** (via [SDKMAN!](https://sdkman.io))

All tool versions are pinned and controlled through a single config file: [`versions.env`](./versions.env).

---

## 🚀 Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/dev-setup.git
cd dev-setup
./setup.sh
source ~/.bashrc   # or source ~/.zshrc
```

---

## 📂 Project Structure

| File          | Description                                                     |
|---------------|-----------------------------------------------------------------|
| `setup.sh`    | Installs all tools using pinned versions in `versions.env`      |
| `check.sh`    | Verifies that installed tools match the pinned versions         |
| `update.sh`   | Applies any version changes from `versions.env` to the system   |
| `versions.env`| Defines the desired version of each tool                        |

---

## 📌 Version Pinning

The file [`versions.env`](./versions.env) contains all tool versions used by `setup.sh`, `check.sh`, and `update.sh`.

Example:

```env
RUST_VERSION=1.86.0
GO_VERSION=1.24.3
JAVA_VERSION=21-tem
SCALA_VERSION=3.3.1
SBT_VERSION=1.10.11
GRADLE_VERSION=8.4
```

To upgrade any tool, edit this file and re-run `./update.sh`.

---

## 🛠 Setup from Scratch

```bash
./setup.sh
source ~/.bashrc   # or source ~/.zshrc
```

This installs all tools and updates your shell profile with the appropriate environment variables.

---

## 🧪 Check Installed Versions

To verify that your current system matches the pinned versions:

```bash
./check.sh
```

You’ll get a ✅ for each matching tool or a ❌ with details for mismatches.

---

## 🔄 Update Tools to Match `versions.env`

When you update a version in `versions.env`, apply the change like this:

```bash
vim versions.env        # change e.g., RUST_VERSION=1.88.0
./update.sh             # installs or switches to new version
./check.sh              # optional: verify everything matches
git commit -am "bump rust to 1.88.0"
```

This script only updates tools that are out of date, and skips anything already matching the pinned version.

---

## 🧪 Example: Bump Scala

```bash
# 1. Change version
vim versions.env       # change SCALA_VERSION=3.3.2

# 2. Update toolchain
./update.sh

# 3. Validate everything is correct
./check.sh

# 4. Commit your upgrade
git commit -am "chore: upgrade scala to 3.3.2"
```

---

## 🛣️ Roadmap

- [ ] GitHub Actions: CI to run `check.sh` on every push/PR
- [ ] `bootstrap.sh`: one-liner install (`curl | bash`)
- [ ] Add Python/Poetry version pinning
- [ ] Version-lock shell profiles and alias sets

---

## 🤝 Contributing

This is a personal automation repo but contributions are welcome.  
Feel free to fork, adapt, or send PRs for new tools or improvements.

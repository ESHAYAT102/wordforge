#!/usr/bin/env sh
set -eu

repo_url="https://github.com/ESHAYAT102/wordforge.git"
binary_name="wordforge"
install_dir="${XDG_BIN_HOME:-${HOME}/.local/bin}"
clone_dir=""

cleanup() { if [ -n "${clone_dir:-}" ] && [ -d "$clone_dir" ]; then rm -rf "$clone_dir"; fi; }
trap cleanup EXIT INT TERM

install_repo() {
  name="$1"
  url="$2"
  clone_dir="$(mktemp -d "${TMPDIR:-/tmp}/$name.XXXXXX")"
  echo "cloning $url"
  git clone --depth 1 "$url" "$clone_dir"
  echo "building $name"
  (cd "$clone_dir" && go build -o "$install_dir/$name" .)
  chmod +x "$install_dir/$name"
  echo "installed $name to $install_dir/$name"
  rm -rf "$clone_dir"
  clone_dir=""
}

install_dependencies() {
  install_repo "crwl" "https://github.com/ESHAYAT102/crwl.git"
  install_repo "lapip" "https://github.com/ESHAYAT102/lapip.git"
  install_repo "crack" "https://github.com/ESHAYAT102/crack.git"
}

command -v go >/dev/null 2>&1 || { echo "error: Go is required" >&2; exit 1; }
command -v git >/dev/null 2>&1 || { echo "error: git is required" >&2; exit 1; }

mkdir -p "$install_dir"

answer=""
if [ -r /dev/tty ]; then
  printf "Install dependency packages (crwl, lapip, crack)? [Y/n] " >/dev/tty
  read -r answer </dev/tty || answer=""
fi
case "$answer" in
  n|N) echo "skipping dependency packages" ;;
  *) install_dependencies ;;
esac

install_repo "$binary_name" "$repo_url"

case ":$PATH:" in
  *":$install_dir:"*) ;;
  *) echo "warning: $install_dir is not in PATH"; echo "add: export PATH=\"$install_dir:\$PATH\"" ;;
esac

#!/usr/bin/env sh
set -eu

binary_path="${XDG_BIN_HOME:-${HOME}/.local/bin}/wordforge"
if [ -e "$binary_path" ]; then
  rm -f "$binary_path"
  echo "removed wordforge from $binary_path"
else
  echo "wordforge was not found at $binary_path"
fi

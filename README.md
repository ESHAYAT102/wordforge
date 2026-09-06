# wordforge

`wordforge` combines the three tools into one workflow:

1. `crwl` renders a URL and extracts words.
2. `lapip` selects the most frequent words.
3. `crack` creates two-word password combinations.

## Requirements

- Go 1.22 or newer when building from source
- `crwl`, `lapip`, and `crack` installed and available on `PATH`
- Chromium or Google Chrome for `crwl`

## Install

Linux and macOS:

```sh
curl -fsSL https://raw.githubusercontent.com/ESHAYAT102/wordforge/main/scripts/install.sh | sh
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/ESHAYAT102/wordforge/main/scripts/install.ps1 | iex
```

The binary is installed to `~/.local/bin/wordforge` on Linux and macOS, or
`$HOME\.local\bin\wordforge.exe` on Windows.

Install `crwl`, `lapip`, and `crack` separately before running the pipeline.
They can also be built locally and placed on `PATH`.

## Usage

Build the three tools and place `crwl`, `lapip`, and `crack` on your `PATH`,
then run:

```sh
go build -o wordforge .
./wordforge -u example.com -t 20 -o passwords.txt
```

The final file contains one generated password per line. The intermediate
`words.txt` and `top.txt` files are written to the current working directory.

The intermediate files are intentionally kept so the extracted and selected
wordlists can be inspected or reused.

## Flags

```text
-u URL       target URL (required)
-t N         number of words passed to crack (default 10)
-o FILE      final output file (default passwords.txt)
```

## Build From Source

```sh
git clone https://github.com/ESHAYAT102/wordforge.git
cd wordforge
go build -o wordforge .
```

## Uninstall

Linux and macOS:

```sh
curl -fsSL https://raw.githubusercontent.com/ESHAYAT102/wordforge/main/scripts/uninstall.sh | sh
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/ESHAYAT102/wordforge/main/scripts/uninstall.ps1 | iex
```

## Responsible Use

Only crawl websites and generate password lists for systems and data you own
or are explicitly authorized to test.

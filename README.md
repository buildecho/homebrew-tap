
# Echo Homebrew tap

The official [Homebrew](https://brew.sh) tap for Echo's developer tools. Install and upgrade them with the same `brew` commands you use for everything else on your Mac.

| Formula | Description | Install |
| :-- | :-- | :-- |
| `go` | Echo build of the Go toolchain | `brew install buildecho/tap/go` |

## Echo Go toolchain

The Echo Go toolchain is the standard Go release, with the same version numbers and the same `go` commands, extended to work with Echo's patched Go modules.

Downloads require an Echo Libraries key, and the formula is available for macOS on Apple silicon and Intel.

### Install

1. Add your credentials to `~/.netrc`. Homebrew uses this entry to download the toolchain:

   ```text
   machine golang.echohq.com
     login et-N
     password ACCESS_KEY
   ```

   Replace `et-N` with your token username and `ACCESS_KEY` with your Libraries key. If you already use Echo Go modules, this entry is already there: the same entry covers the toolchain and your module downloads.

2. Make the file readable only by you:

   ```bash
   chmod 600 ~/.netrc
   ```

3. Install the toolchain with its full name:

   ```bash
   brew install buildecho/tap/go
   ```


4. Confirm the installation:

   ```bash
   go version
   ```

   The output shows the installed release, for example `go1.27.2`.

5. Point Go at Echo's module proxy so your builds pick up Echo's patched modules:

   ```bash
   go env -w GOPROXY=https://golang.echohq.com
   ```

### Upgrade

Upgrade with the rest of your Homebrew packages, or on its own:

```bash
brew upgrade buildecho/tap/go
```

## Support

For help with installation or your Libraries key, contact [support@echohq.com](mailto:support@echohq.com). Service status is available at [status.echo.ai](https://status.echo.ai).

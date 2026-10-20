require_relative "../lib/echo_netrc_download_strategy"

class Go < Formula
  desc "Echo's Go toolchain"
  homepage "https://golang.echohq.com/dl/"
  url "https://golang.echohq.com/dl/go1.27.3.darwin-arm64+echo.2.tar.gz",
    using: EchoNetrcDownloadStrategy
  version "1.27.3+echo.2"
  sha256 "0333e57ffd1145cd790ab0ebd1dcd71df008df0bce24e914517373221ed45cc8"
  license "BSD-3-Clause"

  depends_on :macos

  on_macos do
    on_intel do
      url "https://golang.echohq.com/dl/go1.27.3.darwin-amd64+echo.2.tar.gz",
        using: EchoNetrcDownloadStrategy
      sha256 "3023987f78a576dc28b0ae8b5372ca557dee079e6a0f29dbfc1b80767ebc97fd"
    end
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/go", libexec/"bin/gofmt"
  end

  def caveats
    <<~EOS
      Remove any GOROOT export and older Go installs (e.g. /usr/local/go) from your PATH.
    EOS
  end

  test do
    assert_match "go#{version.to_s.split("+").first} ", shell_output("#{bin}/go version")
  end
end

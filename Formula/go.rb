require_relative "../lib/echo_netrc_download_strategy"

class Go < Formula
  desc "Echo's Go toolchain"
  homepage "https://golang.echohq.com/dl/"
  url "https://golang.echohq.com/dl/go1.27.2.darwin-arm64+echo.1.tar.gz",
    using: EchoNetrcDownloadStrategy
  version "1.27.2+echo.1"
  sha256 "d761d422956cdbd3a2695025bad5a2ed136211a9fc5053c26601d5e0d2f0cb87"
  license "BSD-3-Clause"

  depends_on :macos

  on_macos do
    on_intel do
      url "https://golang.echohq.com/dl/go1.27.2.darwin-amd64+echo.1.tar.gz",
        using: EchoNetrcDownloadStrategy
      sha256 "bc178740da749654aee3f592709f4150b9af8322e2e91f25b5baff5b3e9cd804"
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

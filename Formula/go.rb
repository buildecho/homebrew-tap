require_relative "../lib/echo_go_release"

class Go < Formula
  desc "Echo's Go toolchain"
  homepage "https://golang.echohq.com/dl/"
  # url, version and sha256 of the newest build in golang.echohq.com/dl/VERSION,
  # so `brew upgrade` picks up every new Echo build. The pinned build below is
  # the offline fallback.
  EchoGoRelease.latest(
    "1.27.3+echo.2",
    "arm64" => "0333e57ffd1145cd790ab0ebd1dcd71df008df0bce24e914517373221ed45cc8",
    "amd64" => "3023987f78a576dc28b0ae8b5372ca557dee079e6a0f29dbfc1b80767ebc97fd",
  ).define(self)
  license "BSD-3-Clause"

  depends_on :macos

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

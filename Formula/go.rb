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
    <<~EOS + goproxy_caveat.to_s
      Remove any GOROOT export and older Go installs (e.g. /usr/local/go) from your PATH.
    EOS
  end

  # A GOPROXY set with `go env -w` overrides the toolchain's default, so warn
  # when it bypasses Echo's proxy (or the mirror's). A GOPROXY exported in the
  # shell can't be seen here, because brew filters the environment.
  def goproxy_caveat
    return unless (bin/"go").exist?

    begin
      current = with_env(GOTOOLCHAIN: "local") { Utils.safe_popen_read(bin/"go", "env", "GOPROXY") }.strip
    rescue ErrorDuringExecution
      return
    end
    mirror = ENV.fetch("HOMEBREW_ECHO_GO_MIRROR", "").delete_suffix("/")
    want = if mirror.empty?
      "https://golang.echohq.com"
    elsif mirror.include?("/artifactory/")
      mirror.sub("/artifactory/", "/artifactory/api/go/")
    end
    host = ->(url) { url.split(/[,|]/).first.to_s.sub(%r{\Ahttps?://}, "").delete_suffix("/") }
    return if want && host.call(current) == host.call(want)

    current = "unset" if current.empty?
    if mirror.empty?
      problem = "GOPROXY is #{current}, so Go won't fetch Echo's patched modules"
      fix = "go env -u GOPROXY"
    else
      problem = "GOPROXY is #{current}, not your repository's Go proxy"
      fix = "go env -w GOPROXY=#{want || "<your repository's Go proxy URL>"}"
    end
    <<~EOS

      #{problem}. Run:
        #{fix}
    EOS
  end

  test do
    assert_match "go#{version.to_s.split("+").first} ", shell_output("#{bin}/go version")
  end
end

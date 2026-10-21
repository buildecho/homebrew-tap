# typed: strict
# frozen_string_literal: true

require_relative "echo_netrc_download_strategy"

# The newest Echo Go toolchain build: its version from /dl/VERSION and its
# macOS archives' SHA-256s from the /dl/ index, both read through
# HOMEBREW_ECHO_GO_MIRROR when it is set. Falls back to the given build when
# either can't be read (offline, or the mirror doesn't serve them).
class EchoGoRelease
  DL = "https://golang.echohq.com/dl"
  ARCHES = %w[arm64 amd64].freeze

  attr_reader :version

  def self.latest(fallback_version, fallback_sha256s)
    @latest ||= resolve || new(fallback_version, fallback_sha256s)
  end

  def self.resolve
    build = fetch("VERSION")&.strip
    m = build&.match(/\Ago(?<go>\d+\.\d+\.\d+)\+(?<echo>echo\.\d+)\z/)
    return unless m

    index = fetch("index.html")
    return unless index

    sha256s = ARCHES.to_h do |arch|
      file = Regexp.escape("go#{m[:go]}.darwin-#{arch}+#{m[:echo]}.tar.gz")
      [arch, index[%r{#{file}</a>.*?<code>(\h{64})</code>}m, 1]]
    end
    return if sha256s.value?(nil)

    new("#{m[:go]}+#{m[:echo]}", sha256s)
  end

  def self.fetch(file)
    result = Utils::Curl.curl_output(
      "--fail", "--netrc", "--location",
      EchoNetrcDownloadStrategy.mirrored("#{DL}/#{file}"),
      max_time: 10, retries: 0
    )
    result.stdout if result.success?
  end

  def initialize(version, sha256s)
    @version = version
    @sha256s = sha256s
  end

  # Sets the formula's url, version and sha256 to this build: Apple silicon by
  # default, Intel on Intel Macs.
  # on_macos/on_intel yield without changing self, hence formula. throughout.
  def define(formula)
    formula.url url("arm64"), using: EchoNetrcDownloadStrategy
    formula.version version
    formula.sha256 sha256("arm64")
    formula.on_macos do
      formula.on_intel do
        formula.url url("amd64"), using: EchoNetrcDownloadStrategy
        formula.sha256 sha256("amd64")
      end
    end
  end

  def url(arch)
    go, echo = version.split("+")
    "#{DL}/go#{go}.darwin-#{arch}+#{echo}.tar.gz"
  end

  def sha256(arch)
    @sha256s.fetch(arch)
  end
end

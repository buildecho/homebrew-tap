# typed: strict
# frozen_string_literal: true

# Authenticates downloads with credentials from ~/.netrc.
# HOMEBREW_ECHO_GO_MIRROR swaps golang.echohq.com for a private mirror of it.
class EchoNetrcDownloadStrategy < CurlDownloadStrategy
  def self.mirrored(url)
    mirror = ENV.fetch("HOMEBREW_ECHO_GO_MIRROR", "").delete_suffix("/")
    mirror.empty? ? url : url.sub(%r{\Ahttps://golang\.echohq\.com}, mirror)
  end

  def initialize(url, name, version, **meta)
    super
    @url = self.class.mirrored(@url)
  end

  private

  def _curl_args
    super + ["--netrc"]
  end
end

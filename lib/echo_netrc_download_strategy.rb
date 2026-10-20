# typed: strict
# frozen_string_literal: true

# Authenticates downloads with credentials from ~/.netrc.
# HOMEBREW_ECHO_GO_MIRROR swaps golang.echohq.com for a private mirror of it.
class EchoNetrcDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    mirror = ENV.fetch("HOMEBREW_ECHO_GO_MIRROR", "").delete_suffix("/")
    @url = @url.sub(%r{\Ahttps://golang\.echohq\.com}, mirror) unless mirror.empty?
  end

  private

  def _curl_args
    super + ["--netrc"]
  end
end

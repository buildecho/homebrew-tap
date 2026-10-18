# Authenticates downloads with credentials from ~/.netrc.
class EchoNetrcDownloadStrategy < CurlDownloadStrategy
  private

  def _curl_args
    super + ["--netrc"]
  end
end

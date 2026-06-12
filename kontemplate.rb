# Homebrew binary formula for Kontemplate

class Kontemplate < Formula
  desc "Kontemplate - Extremely simple Kubernetes resource templates"
  homepage "https://github.com/ksquaredkey/kontemplate"
  version "kontemplate-1.11.1-bd60ad8"

  on_intel do
    url "https://github.com/ksquaredkey/kontemplate/releases/download/v1.11.1/kontemplate-1.11.1-bd60ad8-darwin-amd64.tar.gz"
    sha256 "a9a1d54abdff209e1ece58caac552348b474979b8cd192a3fd3bdbe14457bba8"
  end

  on_arm do
    url "https://github.com/ksquaredkey/kontemplate/releases/download/v1.11.1/kontemplate-1.11.1-bd60ad8-darwin-arm64.tar.gz"
    sha256 "3c05264c7166528fb33d07e1ecea9f378604bfc1e75dee7a3327513995c8b4b2"
  end

  def install
    bin.install "kontemplate"
  end
end

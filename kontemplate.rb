# Homebrew binary formula for Kontemplate

class Kontemplate < Formula
  desc "Kontemplate - Extremely simple Kubernetes resource templates"
  homepage "https://github.com/ksquaredkey/kontemplate"
  url "https://github.com/ksquaredkey/kontemplate/releases/download/v1.8.1/kontemplate-1.8.1-656aa15-darwin-amd64.tar.gz"
  sha256 "026d822f9b3df3bdba1db290e920fbc21c4ba9d74722c499069308290feb171e"
  version "kontemplate-1.8.1-656aa15"

  def install
    bin.install "kontemplate"
  end
end

# Homebrew binary formula for Kontemplate

class Kontemplate < Formula
  desc "Kontemplate - Extremely simple Kubernetes resource templates"
  homepage "https://github.com/ksquaredkey/kontemplate"
  url "https://github.com/ksquaredkey/kontemplate/releases/download/v1.10.1/kontemplate-1.10.1-f8d086a-darwin-amd64.tar.gz"
  sha256 "4a52d37745355091cebea63e9b02d2242112c62b148087f4c646f52ad1921e6d"
  version "kontemplate-1.10.1-f8d086a"

  def install
    bin.install "kontemplate"
  end
end

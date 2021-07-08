# Homebrew binary formula for Kontemplate

class Kontemplate < Formula
  desc "Kontemplate - Extremely simple Kubernetes resource templates"
  homepage "https://github.com/ksquaredkey/kontemplate"
  url "https://github.com/ksquaredkey/kontemplate/releases/download/v1.9.0/kontemplate-1.9.0-b5083f6-darwin-amd64.tar.gz"
  sha256 "a98b31de486ebe9b8263f18290f5327942e22f1cf77fae583175220db91af8d9"
  version "kontemplate-1.9.0-b5083f6"

  def install
    bin.install "kontemplate"
  end
end

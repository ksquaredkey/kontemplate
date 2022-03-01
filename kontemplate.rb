# Homebrew binary formula for Kontemplate

class Kontemplate < Formula
  desc "Kontemplate - Extremely simple Kubernetes resource templates"
  homepage "https://github.com/ksquaredkey/kontemplate"
  url "https://github.com/ksquaredkey/kontemplate/releases/download/v1.10.0/kontemplate-1.10.0-4503a01-darwin-amd64.tar.gz"
  sha256 "97b229272780b3001ab797b829118cfa38d978e6f851e886a0241fbbd7685824"
  version "kontemplate-1.10.0-4503a01"

  def install
    bin.install "kontemplate"
  end
end

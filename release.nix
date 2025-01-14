# Copyright (C) 2016-2019  Vincent Ambo <mail@tazj.in>
#
# This file is part of Kontemplate.
#
# Kontemplate is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This file is the Nix derivation used to build release binaries for
# several different architectures and operating systems.

let pkgs = import ((import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs-channels";
  rev = "541d9cce8af7a490fb9085305939569567cb58e6";
  sha256 = "0jgz72hhzkd5vyq5v69vpljjlnf0lqaz7fh327bvb3cvmwbfxrja";
}) {};
in with pkgs; buildGoPackage rec {
  name = "kontemplate-${version}";
  version = "master";
  src = ./.;
  goPackagePath = "github.com/ksquaredkey/kontemplate";
  goDeps = ./deps.nix;

  # This configuration enables the building of statically linked
  # executables. For some reason, those will have multiple references
  # to the Go compiler's installation path in them, which is the
  # reason for setting the 'allowGoReference' flag.
  dontStrip = true; # Linker configuration handles stripping
  allowGoReference = true;
  CGO_ENABLED="0";
  GOCACHE="off";

  # Configure release builds via the "build-matrix" script:
  buildInputs = [ git ];
  buildPhase = ''
    cd go/src/${goPackagePath}
    patchShebangs build-release.sh
    ./build-release.sh build
  '';

  outputs = [ "out" ];
  installPhase = ''
    mkdir $out
    cp -r release/ $out
  '';

  meta = with lib; {
    description = "A resource templating helper for Kubernetes";
    homepage = "http://kontemplate.works/";
    license = licenses.gpl3;
  };
}

#!/usr/bin/env bash
set -eo pipefail

# Copyright (C) 2016-2019  Vincent Ambo <mail@tazj.in>
#
# This file is part of Kontemplate.
#
# Kontemplate is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

readonly GIT_HASH="$(git rev-parse --short HEAD)"
readonly LDFLAGS="-X main.gitHash=${GIT_HASH} -w -s"
readonly VERSION="1.9.0-${GIT_HASH}"

function binary-name() {
    local os="${1}"
    local target="${2}"
    if [ "${os}" = "windows" ]; then
        echo -n "${target}/kontemplate.exe"
    else
        echo -n "${target}/kontemplate"
    fi
}

function build-for() {
    local os="${1}"
    local arch="${2}"
    local goarm="${3}"
    local target="release/${os}/${arch}"
    local bin=$(binary-name "${os}" "${target}")

    echo "Building kontemplate for ${os}-${arch} in ${target}"

    mkdir -p "${target}"

    env GOOS="${os}" GOARCH="${arch}" GOARM="${goarm}" go build \
        -ldflags "${LDFLAGS}" \
        -o "${bin}" \
        -tags netgo
}

function sign-for() {
    local os="${1}"
    local arch="${2}"
    local target="release/${os}/${arch}"
    local bin=$(binary-name "${os}" "${target}")
    local tar="release/kontemplate-${VERSION}-${os}-${arch}.tar.gz"

    echo "Packing release into ${tar}"
    tar czvf "${tar}" -C "${target}" $(basename "${bin}")

    local hash=$(sha256sum "${tar}")
    echo "Signing kontemplate release tarball for ${os}-${arch} with SHA256 ${hash}"
    gpg --armor --detach-sig --sign "${tar}"
}


function make-fat() {
    local os="darwin"
    local arch="fatbin"
    local target="release/${os}/${arch}"
    local bin=$(binary-name "${os}" "${target}")
    local name=$(basename ${bin})
    local tar="release/kontemplate-${VERSION}-${os}-${arch}.tar.gz"

    echo "Packing release into ${tar}"
    mkdir -p "${target}"

    # build Fat Binary - only works on macOS
    lipo -create -output "${bin}" "release/${os}/amd64/$(basename ${bin})" "release/${os}/arm64/$(basename ${bin})"
    tar czvf "${tar}" -C "${target}" $(basename "${bin}")

    local hash=$(sha256sum "${tar}")
    echo "Signing kontemplate release tarball for ${os}-${arch} with SHA256 ${hash}"
    gpg --default-key "ksquaredkey@users.noreply.github.com" --armor --detach-sig --sign "${tar}"
}

case "${1}" in
    "init")
        # set up environment
        rm -rf release
        rm -rf go.mod go.sum
        go mod init github.com/ksquaredkey/kontemplate
        go mod tidy
        exit 0
        ;;
    "build")
        # Build releases for various operating systems:
        # Linux x86_64
        build-for "linux" "amd64"
        # Linux AWS Graviton2
        build-for "linux" "arm64"
        # Raspberry Pi
        build-for "linux" "arm" "5"
        # macOS x86_64
        build-for "darwin" "amd64"
        # macOS M1
        build-for "darwin" "arm64"
        # Windows
        build-for "windows" "amd64"
        # FreeBSD
        build-for "freebsd" "amd64"
        exit 0
        ;;
    "sign")
        # Bundle and sign releases:
        # Linux x86_64
        sign-for "linux" "amd64"
        # Linux AWS Graviton2
        sign-for "linux" "arm64"
        # Raspberry Pi
        sign-for "linux" "arm" "GOARM=5"
        # macOS x86_64
        sign-for "darwin" "amd64"
        # macOS M1
        sign-for "darwin" "arm64"
        # macOS Fat Binary
        make-fat
        # Windows x86_64
        sign-for "windows" "amd64"
        # FreeBSD x86_64
        sign-for "freebsd" "amd64"
        exit 0
        ;;
esac

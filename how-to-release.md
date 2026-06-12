# How to Create a Release

## Prerequisites

- GPG key `ksquaredkey@users.noreply.github.com` available and unlocked
- `gh` CLI authenticated to GitHub
- On macOS (required for the fat binary step in `sign`)

## Steps

### 1. Update the version in `build-release.sh`

Edit the `VERSION` line near the top of `build-release.sh`:

```bash
readonly VERSION="1.11.1-${GIT_HASH}"
```

Replace `1.11.1` with the new release version.

### 2. Update `CHANGELOG.md`

Add a section for the new version at the top of `CHANGELOG.md`.

### 3. Commit the version bump

```bash
git add build-release.sh CHANGELOG.md
git commit -m "release: Create vX.Y.Z"
```

### 4. Build the binaries

```bash
./build-release.sh build
```

Cross-compiles for Linux (amd64/arm64/arm), macOS (amd64/arm64), Windows (amd64), and FreeBSD (amd64) into `release/`.

> If dependencies changed, run `./build-release.sh init` first to regenerate `go.mod`/`go.sum`.

### 5. Package and sign

```bash
./build-release.sh sign
```

Tarballs each platform binary, signs with GPG, and creates a macOS fat binary. Output files follow the pattern:

```
release/kontemplate-<version>-<githash>-<os>-<arch>.tar.gz
release/kontemplate-<version>-<githash>-<os>-<arch>.tar.gz.asc
```

### 6. Tag and push

Both tags point to the same commit. The `-image` tag marks the exact source commit that the release artifacts were built from — the git hash embedded in the filenames should match this commit.

```bash
git tag vX.Y.Z
git tag vX.Y.Z-image
git push origin vX.Y.Z vX.Y.Z-image
```

### 7. Create the GitHub release and upload assets

```bash
VERSION_GLOB="release/kontemplate-X.Y.Z-*"

gh release create vX.Y.Z \
  ${VERSION_GLOB}-linux-amd64.tar.gz \
  ${VERSION_GLOB}-linux-amd64.tar.gz.asc \
  ${VERSION_GLOB}-linux-arm64.tar.gz \
  ${VERSION_GLOB}-linux-arm64.tar.gz.asc \
  ${VERSION_GLOB}-linux-arm.tar.gz \
  ${VERSION_GLOB}-linux-arm.tar.gz.asc \
  ${VERSION_GLOB}-darwin-amd64.tar.gz \
  ${VERSION_GLOB}-darwin-amd64.tar.gz.asc \
  ${VERSION_GLOB}-darwin-arm64.tar.gz \
  ${VERSION_GLOB}-darwin-arm64.tar.gz.asc \
  ${VERSION_GLOB}-darwin-fatbin.tar.gz \
  ${VERSION_GLOB}-darwin-fatbin.tar.gz.asc \
  ${VERSION_GLOB}-windows-amd64.tar.gz \
  ${VERSION_GLOB}-windows-amd64.tar.gz.asc \
  ${VERSION_GLOB}-freebsd-amd64.tar.gz \
  ${VERSION_GLOB}-freebsd-amd64.tar.gz.asc \
  --repo ksquaredkey/kontemplate \
  --title "vX.Y.Z <short description>" \
  --notes "<release notes>"
```

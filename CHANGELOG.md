# Changelog

## v1.11.1 (2026-06-12)

### Bug Fixes

- **Unlimited `include:` nesting depth** — resource set collections previously silently ignored
  any `include:` entries beyond a single level of nesting. The path flattening logic is now
  recursive, so deeply nested collections (3+ levels) resolve correctly with proper name
  hierarchy, absolute paths, and inherited variable merging at each level.

### Build

- `build-release.sh init` now pins `github.com/imdario/mergo` to `v0.3.16` and adds a `replace`
  directive for the `gopkg.in/alecthomas/kingpin.v2` → `github.com/alecthomas/kingpin/v2` module
  rename, so `init` produces a working `go.mod` without manual intervention.

---

## v1.10.1 (2022-03-01)

### New Features

- **Server-Side Apply (`--ssa`)** — `kontemplate apply` now accepts an `--ssa` flag that passes
  `--server-side` to `kubectl apply`. Useful for resources whose manifests exceed the
  `kubectl.kubernetes.io/last-applied-configuration` annotation size limit.

### Bug Fixes

- Deduplicated the `--dry-run` argument-building logic in `applyCommand` (previously the
  `kubectlArgs` slice was being assembled twice, with the second assignment silently discarding
  the first).
- Fixed inconsistent indentation in `deleteCommand`.

---

## v1.10.0 / v1.9.0

- Added `--server` flag to `apply` for server-side dry-runs (`--dry-run=server`).
- Added `--ignore` flag to `delete` to pass `--ignore-not-found=true` to kubectl.
- Added macOS Fat Binary (universal arm64+amd64), Linux ARM64, and Linux ARM builds to the
  release matrix.

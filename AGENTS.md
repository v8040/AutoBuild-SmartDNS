# AGENTS.md

## Project
CI/CD-only repo. No source code. No local build, test, or lint commands.

## Build
- Workflow: `.github/workflows/build.yml`
- Trigger: `workflow_dispatch` only (manual, no push/PR)
- Produces: 7-arch statically-linked SmartDNS binaries → Docker image + GitHub Release

## Dockerfile Contract
- Expects binaries at `bin/${TARGETARCH}/${TARGETVARIANT}/smartdns`
- Expects config at `etc/smartdns.conf`
- These are staged by the `Docker Context` CI step

## Architecture Mapping (CI matrix → Docker platform)
| CI arch   | Docker dir    | Notes                    |
|-----------|---------------|--------------------------|
| x86_64    | bin/amd64     |                          |
| x86       | bin/386       |                          |
| aarch64   | bin/arm64     |                          |
| armel     | bin/arm/v5    |                          |
| armhf     | bin/arm/v7    |                          |
| mipsel    | —             | Release only, no Docker  |
| mips      | —             | Release only, no Docker  |

## Secrets
- `GITHUB_TOKEN` — used by `gh api` (GitHub API calls), release management, GHCR login
- `DOCKERHUB_USERNAME` / `DOCKERHUB_TOKEN` — Docker Hub push

## Runner
All tools are pre-installed on `ubuntu-latest`. No `apt-get` required.
- GitHub API: `gh api --jq` (replaces `curl | jq`)
- Download/file ops: `curl`, `tar`, `git` (pre-installed)

## Upstream Dependencies
- SmartDNS: `pymumu/smartdns` (cloned at build time, latest HEAD)
- OpenSSL: `openssl/openssl` (latest 3.4+ release via `gh api`, statically compiled)
- Toolchain: Bootlin (musl, stable, auto-resolved latest)

## Jobs (build.yml)
| Job | Needs | Description |
|-----|-------|-------------|
| `Build` | — | Cross-compiles SmartDNS for all 7 architectures via matrix; uploads per-arch artifacts |
| `Docker` | `Build` | Downloads artifacts, stages `bin/` and `etc/`, builds & pushes multi-arch image to Docker Hub + GHCR |
| `Release` | `Build` | Fetches upstream SmartDNS release tag, creates/updates GitHub Release with 7 binary artifacts |

## Custom Actions
- `.github/actions/release` — Composite action wrapping `gh release` (create/edit/upload with retry, artifact replacement, `makeLatest`/`prerelease` support). Used by `Release` job, replacing the commented-out `ncipollo/release-action`.

## Housekeeping
- `Cleanup` step (Release job): Uses `ophub/delete-releases-workflows@main` to auto-remove old releases (keeps 5 latest) and workflow runs (keeps 2 days).

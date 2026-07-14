# AutoBuild SmartDNS

[SmartDNS](https://github.com/pymumu/smartdns) 静态编译项目, 通过 GitHub Actions 自动化构建,
交叉编译为静态链接二进制文件, 并打包成 Docker 镜像, 推送到 Docker Hub 和 GHCR

## 构建

所有构建通过手动触发 [build.yml](.github/workflows/build.yml) (`workflow_dispatch`),
并推送到:

- **Docker Hub**: `v8040/smartdns:latest`
- **GHCR**: `ghcr.io/v8040/smartdns:latest`

| 架构 | Docker |
|---------|--------------|
| x86_64  | linux/amd64  |
| x86     | linux/386    |
| aarch64 | linux/arm64  |
| armel   | linux/arm/v5 |
| armhf   | linux/arm/v7 |
| mipsel  | - |
| mips    | - |

## 特性
- 完整静态链接 (musl libc)
- 内置 `OpenSSL 3.4+`, 原生支持 `DoQ/DoH3`
- 基于 [Bootlin Toolchains](https://toolchains.bootlin.com) (GCC 稳定版)

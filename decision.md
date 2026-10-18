# 关键工程决策日志

> 记录 fork patch、换版本、**破坏性接口变更**、架构取舍。
> 格式见 `foray_docs/repository_structure.md` §7.2。

---

## Decision

Date: 2026-02-19

Context: 本仓从 0 初始化。需要确定它在整体架构中的位置与依赖边界。

Decision: 本仓定位为 **META** 层，owner 角色为「架构」，
依赖层级 无。

Reason:
- 切分判据 C1–C6 见 `foray_docs/repository_structure.md` §1
- 粒度结论：**一个仓 = 一个团队角色 + 一个变更率档位**
- **零业务代码。** 整机 tag = 可复现的「那一台能跑的车」

Alternatives:
- 并入相邻仓（减少仓库数量，但违反团队边界或变更率差异）

Rejected:
- 按 ROS 2 package 粒度切仓 —— 会导致版本矩阵地狱
- 按分层机械切仓 —— 会切断团队边界（Conway）

---

## Decision

Date: 2026-10-19

Context: `foray_platform_driver_livox` 直接封装 Livox SDK2，需要确定 SDK 是否
fork 到组织、如何固定版本、开发机与实机如何取得 SDK。

Decision:
- **不 fork、不使用 git submodule、不使用 FetchContent**；Livox-SDK2 无源码修改，
  构建参数（CMake policy、`-include cstdint`）由脚本处理，不构成 patch；
- 在 `.repos` 中 pin `third_party/livox_sdk2` 到 commit
  `f5d9375f84efe2b15bc0a052d3e18482ed13adf4`（v1.3.1）；
- SDK 放在 `src/` 之外，配合 `third_party/COLCON_IGNORE` 与
  `colcon build --base-paths src`，避免被 colcon 当成包；
- 开发机用 `scripts/build_livox_sdk2.sh` 装到
  `~/.cache/foray-platform-prefix/livox-sdk2`；实机镜像固定
  `/opt/foray/livox-sdk2`；
- 驱动 CMake 默认 `FORAY_BUILD_DRIVER_LIVOX=OFF`（stub + mock）；
  启用真实 SDK 时用 `ON` + `PREBUILT` + `LIVOX_SDK2_ROOT`。

Reason:
- 组织规范明确禁止 submodule，厂商 SDK 源码/二进制不得入库；
- 不修改上游时 fork 只会增加同步与许可维护成本；
- `.repos` + 私有前缀让开发机、CI、实机使用同一 commit，且仓库保持干净。

Alternatives:
- fork `Livox-SDK2-foray-fork`：仅在未来必须打 patch 时启用；
- FetchContent：configure 阶段隐式联网，pin 绕过 `.repos` 单一清单；
- 系统包管理器：版本不可控，只能作为次要 `SYSTEM` provider。

Rejected:
- 把 SDK 源码或 `.so` 提交进任何仓库；
- 在 `src/` 下放置第三方 SDK 源码；
- 开发测试强制依赖真实 SDK。

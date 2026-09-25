# foray_ws

> **META** · owner 角色：架构

元仓：.repos 锁定 + 集成 CI + 一键拉取/构建/启动

**零业务代码。** 整机 tag = 可复现的「那一台能跑的车」。

---

## 快速开始

> 本仓处于**初始化状态**，尚无源码。以下流程随 P0/P1 落地逐步可用。

```bash
# 1. 拉取（仓齐备后改为从元仓 foray_ws 一键拉取）
git clone git@github.com:ZQU-Foray/foray_ws.git
cd foray_ws

# 2. 依赖安装
rosdep install -y -r --from-paths . --ignore-src --rosdistro humble

# 3. 构建
colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release

# 4. 运行
# （待装配根就绪后补充）
```

## 依赖

| 类型 | 依赖 |
|---|---|
| **自研仓** | **无**（依赖链最底层） |
| **第三方** | vcstool · colcon · rosdep |

## 接口

| 产出 | 内容 |
|---|---|
| `.repos` | 全部依赖清单，**pin commit** |
| `VERSIONS.md` | 当前整机 tag 包含的各仓 commit |
| 集成 CI | 按 `.repos` 拉全量 → 全量 build → 集成测试 |
| 一键脚本 | 拉取 / 构建 / 启动 |

## 版本锁定：三层机制



| 层 | 机制 |

|---|---|

| 仓级 | 语义化版本 + tag（接口仓尤其严格） |

| 引用级 | 本仓 `.repos` **pin commit**（**不用分支**，不用「大概最新」） |

| 整机级 | **本仓 meta tag**，如 `sentry-2026-regional-v1.0.0` |



## 为什么用 vcstool 而不是 git submodule



| 方案 | 评价 |

|---|---|

| `git submodule` | 原生，但操作繁琐易错（子模块未初始化是新人第一大坑） |

| **`vcstool` + `.repos`** ✅ | SMBU 与 RMOSS 生态均采用；对新手友好；一文件描述全部依赖 |



## 纪律



- **零业务代码**——本仓不出现任何算法实现

- `.repos` 变更**必须说明换版本理由**（评审追加要求）

- 排障第一步：**确认场上跑的是哪个整机 tag**



## 当前阶段



M1（`foray_interfaces` 最小契约集）尚未完成，本仓的 `.repos` 目前只有占位说明。

见 `foray_docs/repository_structure.md` §8 迁移路径。

## 上下游

| 方向 | 对象 |
|---|---|
| **上游**（本仓依赖谁） | 全组织所有仓（以 pin commit 引用） |
| **下游**（谁依赖本仓） | 无（顶层） |

## 参考

- [算法结构](https://github.com/ZQU-Foray/foray_docs/blob/main/algorithm_structure.md)
- [仓库结构](https://github.com/ZQU-Foray/foray_docs/blob/main/repository_structure.md)
- [组织贡献指南](https://github.com/ZQU-Foray/.github/blob/main/CONTRIBUTING.md)

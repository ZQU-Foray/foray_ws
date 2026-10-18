#!/usr/bin/env bash
# 供 source 使用：设置 foray_ws 与 Livox SDK2 环境变量。
#
#   source scripts/env.sh
#   FORAY_LIVOX_SDK2_PREFIX=/opt/foray/livox-sdk2 source scripts/env.sh   # 实机

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "请用 source scripts/env.sh 加载本文件" >&2
    exit 1
fi

FORAY_WS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export FORAY_WS_ROOT

# 开发机默认本地前缀；实机镜像用 /opt/foray/livox-sdk2 覆盖。
export FORAY_LIVOX_SDK2_PREFIX="${FORAY_LIVOX_SDK2_PREFIX:-$HOME/.cache/foray-platform-prefix/livox-sdk2}"
export LIVOX_SDK2_ROOT="${LIVOX_SDK2_ROOT:-$FORAY_LIVOX_SDK2_PREFIX}"

case ":${LD_LIBRARY_PATH:-}:" in
    *":$LIVOX_SDK2_ROOT/lib:"*) ;;
    *) export LD_LIBRARY_PATH="$LIVOX_SDK2_ROOT/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" ;;
esac

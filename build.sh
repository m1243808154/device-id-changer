#!/bin/bash

# Android 设备 ID 修改器编译脚本

echo "════════════════════════════════════════"
echo "  Android 设备 ID 修改器 - 编译脚本"
echo "════════════════════════════════════════"
echo ""

# 检查 NDK 环境
if [ -z "$NDK_ROOT" ] && [ -z "$ANDROID_NDK_HOME" ]; then
    echo "错误: 未设置 NDK 环境变量"
    echo "请设置 NDK_ROOT 或 ANDROID_NDK_HOME"
    echo ""
    echo "示例:"
    echo "  export NDK_ROOT=/path/to/android-ndk"
    echo "  或"
    echo "  export ANDROID_NDK_HOME=/path/to/android-ndk"
    exit 1
fi

# 使用 NDK_ROOT 或 ANDROID_NDK_HOME
if [ -n "$NDK_ROOT" ]; then
    NDK_PATH="$NDK_ROOT"
else
    NDK_PATH="$ANDROID_NDK_HOME"
fi

echo "NDK 路径: $NDK_PATH"
echo ""

# 清理之前的编译
echo "清理之前的编译..."
rm -rf libs obj

# 执行编译
echo "开始编译..."
echo ""

"$NDK_PATH/ndk-build" NDK_PROJECT_PATH=. NDK_APPLICATION_MK=jni/Application.mk

if [ $? -eq 0 ]; then
    echo ""
    echo "════════════════════════════════════════"
    echo "✓ 编译成功！"
    echo "════════════════════════════════════════"
    echo ""
    echo "生成的可执行文件位于:"
    find libs -name "device_id_changer" -type f | while read file; do
        echo "  - $file"
    done
    echo ""
    echo "使用方法:"
    echo "  1. 将对应架构的文件推送到设备:"
    echo "     adb push libs/arm64-v8a/device_id_changer /data/local/tmp/"
    echo ""
    echo "  2. 设置执行权限:"
    echo "     adb shell su -c 'chmod 755 /data/local/tmp/device_id_changer'"
    echo ""
    echo "  3. 运行程序:"
    echo "     adb shell su -c '/data/local/tmp/device_id_changer -r com.example.app'"
    echo ""
else
    echo ""
    echo "════════════════════════════════════════"
    echo "✗ 编译失败"
    echo "════════════════════════════════════════"
    exit 1
fi

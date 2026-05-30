@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ════════════════════════════════════════
echo   Android 设备 ID 修改器 - 编译脚本
echo ════════════════════════════════════════
echo.

REM 检查 NDK 环境
set "NDK_PATH="

if defined NDK_ROOT (
    set "NDK_PATH=%NDK_ROOT%"
) else if defined ANDROID_NDK_HOME (
    set "NDK_PATH=%ANDROID_NDK_HOME%"
) else (
    REM 尝试查找默认位置的 NDK
    if exist "%LOCALAPPDATA%\Android\Sdk\ndk\28.0.13004108" (
        set "NDK_PATH=%LOCALAPPDATA%\Android\Sdk\ndk\28.0.13004108"
        echo 使用默认 NDK 路径: !NDK_PATH!
    ) else if exist "%LOCALAPPDATA%\Android\Sdk\ndk\21.4.7075529" (
        set "NDK_PATH=%LOCALAPPDATA%\Android\Sdk\ndk\21.4.7075529"
        echo 使用默认 NDK 路径: !NDK_PATH!
    ) else (
        echo 错误: 未找到 NDK 安装
        echo 请设置 NDK_ROOT 或 ANDROID_NDK_HOME 环境变量
        echo.
        echo 示例:
        echo   set NDK_ROOT=C:\path\to\android-ndk
        echo   或
        echo   set ANDROID_NDK_HOME=C:\path\to\android-ndk
        exit /b 1
    )
)

echo NDK 路径: %NDK_PATH%
echo.

REM 清理之前的编译
echo 清理之前的编译...
if exist libs rmdir /s /q libs
if exist obj rmdir /s /q obj

REM 执行编译
echo 开始编译...
echo.

call "%NDK_PATH%\ndk-build.cmd" NDK_PROJECT_PATH=. NDK_APPLICATION_MK=jni\Application.mk

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ════════════════════════════════════════
    echo ✓ 编译成功！
    echo ════════════════════════════════════════
    echo.
    echo 生成的可执行文件位于:
    for /r libs %%f in (device_id_changer) do (
        if exist "%%f" echo   - %%f
    )
    echo.
    echo 使用方法:
    echo   1. 将对应架构的文件推送到设备:
    echo      adb push libs\arm64-v8a\device_id_changer /data/local/tmp/
    echo.
    echo   2. 设置执行权限:
    echo      adb shell su -c "chmod 755 /data/local/tmp/device_id_changer"
    echo.
    echo   3. 运行程序:
    echo      adb shell su -c "/data/local/tmp/device_id_changer -r com.example.app"
    echo.
) else (
    echo.
    echo ════════════════════════════════════════
    echo ✗ 编译失败
    echo ════════════════════════════════════════
    exit /b 1
)

endlocal

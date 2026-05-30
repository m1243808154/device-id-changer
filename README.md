# Android 设备标识修改器 v2.0

> 🎉 **交互式版本** - 友好的用户界面 + 强大的命令行支持

一个简单、可靠、安全的 Android 设备标识修改工具，支持交互式操作和命令行自动化。

---

## ✨ 特性

- ✅ **100% 可靠** - 只修改一定生效的标识
- ✅ **交互式操作** - 友好的用户界面，无需记忆命令
- ✅ **命令行支持** - 支持脚本自动化
- ✅ **多用户支持** - 自动处理主空间和小米分身/XSpace 等用户空间
- ✅ **无需 Magisk** - 只需要 root 权限
- ✅ **永久保存** - 重启不丢失
- ✅ **无法律风险** - 仅修改应用级标识
- ✅ **体积小巧** - 仅 ~16KB

---

## 📋 修改内容

| 标识类型 | 可靠性 | 说明 |
|---------|--------|------|
| Android ID (SSAID) | 100% | 应用级设备标识 |
| 广告 ID | 100% | Google 广告标识 |

---

## 🚀 快速开始

### 方式一：交互式模式（推荐）

```bash
# 1. 获取 root 权限
su

# 2. 进入目录
cd /data/local/tmp

# 3. 运行程序
./device_id_changer

# 4. 按照提示操作
# - 输入包名
# - 选择随机或自定义标识
# - 选择是否备份
# - 选择是否清除应用数据
# - 自动执行修改

# 5. 重新打开目标应用
```

### 方式二：命令行模式

```bash
# 查看当前标识
./device_id_changer -s com.example.app

# 使用随机标识
./device_id_changer -r com.example.app

# 备份后修改
./device_id_changer -b -r com.example.app

# 备份、修改并清除应用数据
./device_id_changer -b -r --clear-data com.example.app

# 指定自定义标识
./device_id_changer -a 1234567890abcdef com.example.app
```

---

## 📱 安装

### 1. 选择架构

根据你的设备选择对应的二进制文件：

- **arm64-v8a** - 64位 ARM（大多数现代设备）
- **armeabi-v7a** - 32位 ARM（旧设备）
- **x86_64** - 64位 x86（模拟器）
- **x86** - 32位 x86（旧模拟器）

### 2. 推送到设备

```bash
# 推送文件
adb push libs/arm64-v8a/device_id_changer /data/local/tmp/

# 设置权限
adb shell chmod 755 /data/local/tmp/device_id_changer

# 测试
adb shell su -c "/data/local/tmp/device_id_changer -h"
```

---

## 📖 使用示例

### 示例 1：第一次使用（交互式）

```bash
$ su
# cd /data/local/tmp
# ./device_id_changer

请输入目标应用包名: com.tiktok
是否使用随机生成的设备标识? (y/n): y
是否在修改前备份配置? (y/n): y
是否清除目标应用数据以彻底刷新缓存? (y/n): n

✓ 修改完成！
```

### 示例 2：批量修改（命令行）

```bash
#!/system/bin/sh

apps=(
    "com.tiktok"
    "com.instagram.android"
    "com.facebook.katana"
)

for app in "${apps[@]}"; do
    ./device_id_changer -b -r "$app"
done
```

### 示例 3：测试环境（固定标识）

```bash
./device_id_changer \
    -a 0000000000000000 \
    -d 00000000-0000-0000-0000-000000000000 \
    --clear-data \
    com.example.testapp
```

---

## 🔧 命令行选项

| 选项 | 说明 |
|------|------|
| `-s, --show` | 显示当前设备标识 |
| `-r, --random` | 生成并使用随机的设备标识 |
| `-b, --backup` | 修改前备份配置 |
| `-a, --android-id <ID>` | 指定 Android ID (16位十六进制) |
| `-d, --ad-id <ID>` | 指定广告 ID (UUID格式) |
| `--clear-data` | 修改成功后清除目标应用数据（会删除应用本地数据） |
| `-h, --help` | 显示帮助信息 |

> 如果目标应用安装在小米分身/XSpace 等多用户空间中，工具会自动同时修改这些用户空间里的 SSAID，并在修改成功后分别强制停止目标应用。

---

## 📚 文档

- **[使用说明-交互式版本.md](使用说明-交互式版本.md)** - 详细使用说明（推荐阅读）
- **[快速开始-交互式.txt](快速开始-交互式.txt)** - 快速参考卡片
- **[版本说明.md](版本说明.md)** - 版本历史和对比
- **[更新日志-v2.0.txt](更新日志-v2.0.txt)** - 本次更新详情
- **[技术实现说明.md](技术实现说明.md)** - 技术实现细节

---

## ⚠️ 重要提示

### 修改后自动执行

```bash
# 工具会在修改成功后自动强制停止目标应用
/data/local/tmp/device_id_changer -r com.example.app

# 如目标应用仍使用旧缓存，可显式清除应用数据
/data/local/tmp/device_id_changer -r --clear-data com.example.app
```

### 验证修改

```bash
./device_id_changer -s com.example.app
```

---

## 🔍 故障排除

### 问题 1：提示"需要 root 权限"

```bash
su
./device_id_changer
```

### 问题 2：修改失败

```bash
# 检查 SELinux
getenforce

# 临时禁用 SELinux
setenforce 0

# 检查配置文件
ls -la /data/system/users/0/settings_ssaid.xml
```

### 问题 3：广告 ID 修改失败

这是正常的，设备未安装 Google Play Services。不影响 Android ID 的修改。

---

## 🛠️ 编译

### 环境要求

- Android NDK r21 或更高版本
- Windows/Linux/macOS

### 编译步骤

```bash
# Windows
build.bat

# Linux/macOS
chmod +x build.sh
./build.sh
```

编译输出：
- `libs/armeabi-v7a/device_id_changer`
- `libs/arm64-v8a/device_id_changer`
- `libs/x86/device_id_changer`
- `libs/x86_64/device_id_changer`

---

## 📊 技术细节

### Android ID (SSAID)

- **格式**: 16位十六进制 (0-9, a-f)
- **示例**: `1234567890abcdef`
- **存储**: `/data/system/users/0/settings_ssaid.xml`
- **可靠性**: 100%

### 广告 ID

- **格式**: UUID (8-4-4-4-12)
- **示例**: `12345678-1234-1234-1234-123456789abc`
- **存储**: Google Play Services 配置
- **可靠性**: 100%

---

## 🆚 版本对比

| 特性 | v1.3 | v2.0 |
|------|------|------|
| 交互式模式 | ❌ | ✅ |
| 命令行模式 | ✅ | ✅ |
| 用户友好度 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 学习成本 | 中 | 低 |
| 脚本支持 | ✅ | ✅ |
| 可靠性 | 100% | 100% |
| 向后兼容 | - | ✅ |

---

## 💡 最佳实践

### 1. 首次使用

```bash
# 先查看当前标识
./device_id_changer -s com.example.app

# 备份后修改
./device_id_changer -b -r com.example.app

# 验证修改
./device_id_changer -s com.example.app
```

### 2. 测试环境

```bash
# 使用固定标识便于调试
./device_id_changer \
    -a 0000000000000000 \
    -d 00000000-0000-0000-0000-000000000000 \
    com.example.testapp
```

### 3. 生产环境

```bash
# 使用随机标识增加唯一性
./device_id_changer -b -r com.example.app
```

---

## 📞 常见问题

**Q: 修改是永久的吗？**  
A: 是的，修改会保存到系统配置文件，重启不丢失。

**Q: 会影响其他应用吗？**  
A: 不会，每个应用的 Android ID 是独立的。

**Q: 可以恢复原来的标识吗？**  
A: 可以，使用 `-b` 选项备份后，可以手动恢复备份文件。

**Q: 需要重启手机吗？**  
A: 不需要。工具会在修改成功后自动强制停止目标应用，重新打开即可；如仍有缓存，可使用 `--clear-data`。

**Q: 支持哪些 Android 版本？**  
A: Android 8.0 (Oreo) 及以上版本。

---

## 🔒 安全说明

1. **仅修改应用级标识** - 不涉及硬件修改
2. **无法律风险** - 合法的系统配置修改
3. **需要 root** - 确保用户有完全控制权
4. **建议备份** - 防止意外情况

---

## 📄 许可证

本项目仅供学习和测试使用。使用者需自行承担使用风险。

---

## 🙏 致谢

感谢以下开源项目的启发：
- [CoNsTaRs/oreo_device_id_changer](https://github.com/CoNsTaRs/oreo_device_id_changer)
- [sdex/AndroidIDeditorV2](https://github.com/sdex/AndroidIDeditorV2)

---

## 📈 项目状态

- **版本**: v2.0 交互式版本
- **状态**: 稳定版本
- **维护**: 活跃开发中
- **推荐度**: ⭐⭐⭐⭐⭐

---

## 🔮 未来计划

- [ ] 支持多用户环境
- [ ] 添加配置文件支持
- [ ] 批量修改模式
- [ ] 导入/导出标识
- [ ] GUI 界面（可选）
- [ ] 日志记录功能

---

**立即开始使用 Android 设备标识修改器 v2.0！**

```bash
su
cd /data/local/tmp
./device_id_changer
```

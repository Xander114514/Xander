# 每日打卡

一个仅供个人使用的 SwiftUI iOS 小工具，不需要应用账号或网络。

## 功能

- 显示从本轮起始日期到今天已经坚持的天数
- 显示本轮起始日期，可手动调整
- “今天破戒了”按钮，确认后记录日期并从当天重新计时
- 显示累计破戒次数和所有破戒日期
- 数据保存在本机 `UserDefaults`

## 运行

工程最低支持 iOS 16。没有 Mac 时，可用下面的 Codemagic 工作流云端编译，再用 Windows 侧载工具签名安装。

## 免费安装到自己的 iPhone

项目内附带的 `codemagic.yaml` 会在 Codemagic 云端构建未签名 IPA，不需要付费 Apple Developer Program 会员。构建完成后下载 Artifacts 里的 `.ipa`，在 Windows 上使用 Sideloadly 等侧载工具，并用自己的免费 Apple ID 在本机签名安装。

免费 Apple ID 的侧载签名通常约 7 天到期，需要定期用侧载工具刷新/重装。iPhone 可能需要开启开发者模式。只从工具的官方网站获取安装包；Apple ID 凭据只在本机侧载工具中操作，不要发给他人。Bundle ID 固定为 `com.personal.dailycheckin`。

### 构建步骤

1. 将工程文件上传到 GitHub 仓库根目录，确保 `codemagic.yaml` 在根目录。
2. 在 Codemagic 选择 `ios-personal-build` 工作流并开始构建，不用配置 Apple 开发者签名。
3. 成功后从构建页面下载 `DailyCheckIn.ipa`。
4. 在 Windows 上用侧载工具选择 IPA 和自己的 iPhone，按工具提示完成免费 Apple ID 签名及安装。

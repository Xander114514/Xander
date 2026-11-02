# 每日打卡

一个仅供个人使用的 SwiftUI iOS 小工具，不需要账号或网络。

## 功能

- 显示从本轮起始日期到今天已经坚持的天数
- 显示本轮起始日期，可手动调整
- “今天破戒了”按钮，确认后记录日期并从当天重新计时
- 显示累计破戒次数和所有破戒日期
- 数据保存在本机 `UserDefaults`

## 运行

用 Xcode 打开 `DailyCheckIn.xcodeproj`，然后运行到自己的 iPhone 或模拟器。工程最低支持 iOS 16。

## 没有 Mac 时安装到 iPhone

项目内已经附带 `codemagic.yaml`。在 Windows 上注册并登录 Codemagic，连接包含这些文件的 Git 仓库，选择该配置并使用自己的 Apple Developer 账号完成签名。构建完成后下载生成的 `.ipa`，再按 Codemagic 提供的安装方式装到自己的 iPhone。

Codemagic 的邮件发布地址需要改成你自己的邮箱；也可以直接在 Codemagic 网页中下载构建产物。Bundle ID 已固定为 `com.personal.dailycheckin`，首次签名时在 Apple Developer 后台创建或允许该 App ID。

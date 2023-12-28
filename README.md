# GraceWeapon: 渗透测试环境构建指南

## 项目简介

GraceWeapon旨在为渗透测试者提供一个简洁、快速而又优雅的Docker渗透测试环境。项目通过Docker技术实现环境的快速部署，以及易于管理，旨在提供一种高效和优雅的渗透测试体验。

## zsh 和 Oh My Zsh

GraceWeapon项目特别选择了`zsh`作为命令行界面，结合`Oh My Zsh`框架，以提供丰富的功能和灵活的定制选项。`zsh`是一种强大的shell，提供诸如主题、插件和自动补全等先进特性。`Oh My Zsh`则是一个社区驱动的框架，用于管理zsh的配置，包括大量可供选择的主题和插件，以增强用户体验。

## 工具列表及功能

以下是GraceWeapon中选用的主要渗透测试工具及其功能介绍：

1. **sqlmap**: 用于检测和利用SQL注入漏洞的自动化工具。
   - [sqlmap GitHub](https://github.com/sqlmapproject/sqlmap)
2. **OneForAll**: 一款功能强大的子域名收集工具，用于信息收集。
   - [OneForAll GitHub](https://github.com/shmilylty/OneForAll)
3. **ffuf**: 高速web模糊测试工具，适用于路径发现、子域名枚举等。
   - [ffuf GitHub](https://github.com/ffuf/ffuf)
4. **dirsearch**: web路径扫描工具，用于发现web服务上的隐藏目录和文件。
   - dirsearch GitHub
5. **masscan**: 超快速端口扫描器，用于网络端口的安全检查。
   - [masscan GitHub](https://github.com/robertdavidgraham/masscan)
6. **JSFinder**: 专注于分析JavaScript文件以提取URL和子域名。
   - [JSFinder GitHub](https://github.com/Threezh1/JSFinder)

## 部署指南

GraceWeapon的部署非常直接，以下是基本步骤：

1. **克隆项目**: 从GitHub克隆GraceWeapon项目。

   ```
   git clone https://github.com/your-username/GraceWeapon.git
   ```

2. **启动环境**: 使用docker-compose在后台启动服务。

   ```
   docker-compose up -d
   ```

3. **进入环境**: 使用docker exec命令进入运行中的容器环境。

   ```
   docker exec -it weapon zsh
   ```

4. **退出环境**: 使用Ctrl+D退出容器环境。

5. **关闭环境**: 当测试完成后，可以使用以下命令关闭环境。

   ```
   docker-compose down
   ```

通过这些步骤，您可以快速地部署并使用GraceWeapon渗透测试环境，无需繁琐的配置过程。
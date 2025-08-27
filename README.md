✨ **给个 star 吧！！！** ✨ 

*最近发现有同学偷偷给项目 star 了，非常感谢！但其实不用这么客气～  
毕竟这个工具还在“幼儿园阶段”，功能全靠瞎蒙，bug 比 feature 多 🐛  
（当然，如果你非要给 star，我也不会拒绝… 毕竟作者的咖啡钱全靠 star 众筹 ☕️）*

## Ongwu主题 - 专为GitHub Pages + Hexo 架构打造的自适应主题

一个简洁大气的Hexo博客主题，专注于技术分享、项目展示和教程分享。

### 主题演示：https://ongwu.github.io
### 一键安装脚本windows版：windows一键安装脚本.bat

### 主题截图：

<img width="1905" height="1307" alt="ongwu" src="https://github.com/user-attachments/assets/24a2b834-934b-4770-b5d1-6bcf86f611fb" />

## ✨ 特性

- 🎨 **简洁大气** - 现代化的设计风格，符合技术博客审美
- 📱 **响应式设计** - 完美适配各种设备尺寸
- 🚀 **返回顶部** - 彩色小火箭返回顶部功能
- 🔍 **本地搜索** - 支持文章内容搜索
- 📄 **分页功能** - 技术深究、教程分享、项目作品页面分页
- 🏷️ **标签美化** - 美观的文章标签显示
- 🌐 **友情链接** - 简洁的友情链接展示
- 📱 **移动优化** - 移动端完美体验

## 📁 文件结构

```
hexo-blog/
├── _config.yml                 # Hexo主配置文件
├── themes/
│   └── ongwu/                 # Ongwu主题目录
│       ├── _config.yml        # 主题配置文件
│       ├── layout/            # 布局模板
│       │   ├── layout.ejs     # 主布局文件
│       │   ├── index.ejs      # 首页模板
│       │   ├── projects.ejs   # 项目作品页面
│       │   ├── tech.ejs       # 技术深究页面
│       │   ├── tutorial.ejs   # 教程分享页面
│       │   ├── ranking.ejs    # 踩踩网站页面
│       │   ├── post.ejs       # 文章页面模板
│       │   └── search.ejs     # 搜索功能
│       └── source/            # 主题资源
│           ├── css/           # 样式文件
│           ├── js/            # JavaScript文件
│           └── images/        # 图片资源
└── source/                    # 博客内容
    └── _posts/               # 文章目录，含有示例文章
```

## 🚀 快速部署开始食用

### 1. 安装Hexo

```bash
npm install -g hexo-cli
```

### 2. 创建博客

```bash
hexo init my-blog
cd my-blog
```

### 3. 安装依赖

```bash
npm install
```

### 4. 应用Ongwu主题

1. 下载`ongwu主题`直接复制到你的博客`根目录`下，例如`my-blog`下，执行如下命令（在windows环境下）
```bash
git clone https://github.com/ongwu/ongwu-hexo-theme.git
xcopy .\ongwu-hexo-theme\. /E /I /H
```
2. （可选）修改根目录`_config.yml`文件，由于直接解压，_config.yml文件会覆盖，所以不需要额外修改

```yaml
theme: ongwu
```

### 5. 安装搜索插件

```bash
npm install hexo-generator-search --save
```

### 6. 启动本地服务器

```bash
hexo clean
hexo g
hexo s
```

访问 `http://localhost:4000` 查看即可

## ⚙️ 配置说明

### 主配置文件 (_config.yml)

```yaml
# 网站信息
title: 你的网站标题
subtitle: 你的网站副标题
description: 你的网站描述
keywords: 你的关键词
author: 你的名字

# 主题设置
theme: ongwu

# 搜索配置
search:
  path: search.xml
  field: post
  content: true
  format: html

# 分页配置
per_page: 10
tech_generator:
  path: 'tech'
  per_page: 21
tutorial_generator:
  path: 'tutorial'
  per_page: 21
projects_generator:
  path: 'projects'
  per_page: 20
```

### 主题配置文件 (themes/ongwu/_config.yml)

```yaml
# 网站信息
site_name: "你的网站名称"
site_description: "你的网站描述"
site_keywords: "你的关键词"

# 导航菜单
menu:
  home: "首页"
  projects: "项目作品"
  tech: "技术深究"
  tutorial: "教程分享"
  ranking: "踩踩网站"

# 首页配置文章数
index:
  projects_count: 4
  tech_count: 6
  tutorial_count: 6
```

## 📝 创建文章

### 创建普通文章

```bash
hexo new "文章标题"
```

### 创建分类文章

```bash
# 项目作品
hexo new "项目名称" --path projects/项目名称

# 技术深究
hexo new "技术文章" --path tech/技术文章

# 教程分享
hexo new "教程标题" --path tutorial/教程标题
```

### 文章Front-matter示例

```yaml
---
title: 文章标题
date: 2025-01-10 10:00:00
categories: 
  - projects  # 或 tech, tutorial
tags:
  - 标签1
  - 标签2
thumbnail: /images/thumbnail.jpg
description: 文章描述
---
```

## 🎨 自定义样式

主题样式文件位于 `themes/ongwu/source/css/style.css`，你可以根据需要修改：

- 颜色变量
- 布局样式
- 响应式断点
- 动画效果

## 🚀 部署到GitHub Pages

### 1. 安装部署插件

```bash
npm install hexo-deployer-git --save
```

### 2. 配置部署信息

在`_config.yml`中添加：

```yaml
deploy:
  type: git
  repo: https://github.com/用户名/仓库名.git
  branch: main
```

### 3. 生成并部署

```bash
hexo clean
hexo generate
hexo deploy
```

### 4. 设置GitHub Pages

1. 在GitHub仓库设置中启用Pages
2. 选择部署分支（通常是main或gh-pages）
3. 设置自定义域名（可选）

## 📱 响应式设计

主题支持以下断点：

- **桌面端** (>1200px): 完整布局
- **中等屏幕** (768px-1200px): 适中布局
- **平板端** (480px-768px): 平板优化
- **手机端** (<480px): 移动端优化

## 🔧 常见问题

### Q: 搜索功能不工作？
A: 确保安装了`hexo-generator-search`插件，并生成了`search.xml`文件。

### Q: 分页功能异常？
A: 检查`_config.yml`中的分页配置，确保路径和数量设置正确。

### Q: 样式没有生效？
A: 运行`hexo clean`清理缓存，然后重新生成。

### Q: 图片无法显示？
A: 确保图片路径正确，建议使用相对路径。

## 📄 许可证

MIT License

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个主题！

## 📞 联系方式

如有问题，请通过以下方式联系：

- GitHub Issues
- 邮箱：[ongwu007@qq.com]

---

**Ongwu主题** - 让技术博客更优雅 🚀

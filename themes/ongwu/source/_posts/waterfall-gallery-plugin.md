---
title: WaterfallGallery
date: 2025-01-14
categories: 
  - tech
tags:
  - ongwu插件
  - 瀑布流
  - 相册
subtitle: ongwu相册插件，支持瀑布流布局和多种展示模式
icon: /images/tech/waterfall-icon.png
---

# WaterfallGallery - ongwu相册插件

## 插件简介

WaterfallGallery是一个专为ongwu博客系统开发的相册插件，支持瀑布流布局和多种展示模式。通过这个插件，你可以轻松地在博客中展示图片，支持图片懒加载、响应式布局等功能。

## 主要功能

### 1. 瀑布流布局
- 自动计算图片尺寸
- 智能排列，充分利用空间
- 支持不同宽度的图片混排

### 2. 多种展示模式
- 网格模式：整齐的网格排列
- 瀑布流模式：动态高度排列
- 幻灯片模式：全屏幻灯片展示

### 3. 图片管理
- 支持批量上传
- 自动生成缩略图
- 图片分类和标签

## 技术实现

### 前端技术
```javascript
// 瀑布流布局算法
function waterfallLayout(container, items) {
    const containerWidth = container.offsetWidth;
    const itemWidth = 300; // 固定宽度
    const gap = 20; // 间距
    const columns = Math.floor(containerWidth / (itemWidth + gap));
    
    const heights = new Array(columns).fill(0);
    
    items.forEach(item => {
        const minHeight = Math.min(...heights);
        const columnIndex = heights.indexOf(minHeight);
        
        const left = columnIndex * (itemWidth + gap);
        const top = minHeight;
        
        item.style.position = 'absolute';
        item.style.left = left + 'px';
        item.style.top = top + 'px';
        
        heights[columnIndex] += item.offsetHeight + gap;
    });
}
```

### 后端实现
```php
<?php
class WaterfallGallery_Plugin implements ongwu_Plugin_Interface
{
    public static function activate()
    {
        // 创建数据表
        $db = ongwu_Db::get();
        $prefix = $db->getPrefix();
        
        $sql = "CREATE TABLE IF NOT EXISTS `{$prefix}waterfall_gallery` (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `title` varchar(255) NOT NULL,
            `description` text,
            `image_url` varchar(500) NOT NULL,
            `thumbnail_url` varchar(500),
            `category` varchar(100),
            `tags` text,
            `created` int(11) NOT NULL,
            `modified` int(11) NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;";
        
        $db->query($sql);
        
        return _t('插件启用成功');
    }
    
    public static function deactivate()
    {
        return _t('插件禁用成功');
    }
}
?>
```

## 安装配置

### 1. 下载插件
从GitHub下载最新版本的插件文件。

### 2. 上传文件
将插件文件上传到ongwu的`usr/plugins/`目录。

### 3. 启用插件
在ongwu后台的"插件管理"中启用WaterfallGallery插件。

### 4. 配置设置
```php
// 在模板中使用
<?php $this->widget('Widget_Archive@waterfall', 'type=waterfall')->to($waterfall); ?>
<?php while($waterfall->next()): ?>
    <div class="gallery-item">
        <img src="<?php $waterfall->imageUrl(); ?>" alt="<?php $waterfall->title(); ?>">
        <div class="gallery-info">
            <h3><?php $waterfall->title(); ?></h3>
            <p><?php $waterfall->description(); ?></p>
        </div>
    </div>
<?php endwhile; ?>
```

## 使用示例

### 基础用法
```html
<div class="waterfall-gallery">
    <div class="gallery-item">
        <img src="/images/photo1.jpg" alt="照片1">
        <div class="gallery-info">
            <h3>美丽的风景</h3>
            <p>这是一张美丽的风景照片</p>
        </div>
    </div>
    <!-- 更多图片... -->
</div>
```

### 自定义样式
```css
.waterfall-gallery {
    position: relative;
    margin: 0 auto;
}

.gallery-item {
    position: absolute;
    width: 300px;
    background: #fff;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    transition: transform 0.3s ease;
}

.gallery-item:hover {
    transform: translateY(-5px);
    box-shadow: 0 5px 20px rgba(0,0,0,0.15);
}

.gallery-item img {
    width: 100%;
    height: auto;
    display: block;
}

.gallery-info {
    padding: 15px;
}

.gallery-info h3 {
    margin: 0 0 10px 0;
    font-size: 16px;
    color: #333;
}

.gallery-info p {
    margin: 0;
    color: #666;
    font-size: 14px;
    line-height: 1.4;
}
```

## 性能优化

### 1. 图片懒加载
```javascript
// 使用Intersection Observer API
const imageObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const img = entry.target;
            img.src = img.dataset.src;
            img.classList.remove('lazy');
            imageObserver.unobserve(img);
        }
    });
});

document.querySelectorAll('img[data-src]').forEach(img => {
    imageObserver.observe(img);
});
```

### 2. 缩略图优化
- 自动生成多种尺寸的缩略图
- 根据设备像素比选择合适的图片
- 支持WebP格式

## 常见问题

### Q: 插件支持哪些图片格式？
A: 支持JPG、PNG、GIF、WebP等常见格式。

### Q: 如何自定义瀑布流的列数？
A: 可以通过CSS媒体查询或JavaScript动态调整。

### Q: 插件是否支持移动端？
A: 完全支持，采用响应式设计。

## 更新日志

### v1.2.0 (2025-01-14)
- 新增瀑布流布局算法
- 优化图片懒加载性能
- 修复移动端显示问题

### v1.1.0 (2025-01-10)
- 新增多种展示模式
- 支持图片分类和标签
- 优化后台管理界面

### v1.0.0 (2025-01-05)
- 初始版本发布
- 基础相册功能
- 响应式设计支持

## 下载地址

- GitHub: [https://github.com/username/waterfall-gallery](https://github.com/username/waterfall-gallery)
- 插件主页: [https://waterfall-gallery.ongwu.cn](https://waterfall-gallery.ongwu.cn)

## 许可证

GPL v2

---

*WaterfallGallery - 让图片展示更优雅*

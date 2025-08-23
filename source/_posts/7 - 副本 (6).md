---
title: "让ongwu支持搜索符号"
subtitle: "修改源码实现符号搜索功能"
date: 2025-01-09
categories: 
  - tutorial
tags:
  - ongwu
  - 搜索功能
  - 源码修改
  - 符号搜索
description: "用过ongwu的应该都清楚它本身搜索是不支持符号的，一般都会过滤掉，只会保留文字字母数字进行搜索。本文讲解如何通过修改源码的方式实现符号搜索。"
icon: /images/tutorial/search-icon.png
---

# 让ongwu支持搜索符号

## 问题背景

用过ongwu的应该都清楚它本身搜索是不支持符号的，一般都会过滤掉，只会保留文字字母数字进行搜索。这种过滤应该是出于安全考虑的，但如果你的需求需要搜索符号之类的东西，则可以通过修改源码的方式实现。

## 修改原理

ongwu的搜索功能是在`var/Widget/Archive.php`中实现的，所以需要修改两处代码：

### 第一处：关键词过滤逻辑

在`var/Widget/Archive.php`文件中找到以下代码：

```php
// 原始代码
$filterKeywords = $this->request->get('keywords');
$filterKeywords = trim($filterKeywords);
$filterKeywords = str_replace(array('+', '-', '&', '|', '!', '(', ')', '{', '}', '[', ']', '^', '"', '~', '*', '?', ':', '\\'), '', $filterKeywords);
```

修改为：

```php
// 修改后的代码
$filterKeywords = $this->request->get('keywords');
$filterKeywords = trim($filterKeywords);
// 注释掉或删除符号过滤代码
// $filterKeywords = str_replace(array('+', '-', '&', '|', '!', '(', ')', '{', '}', '[', ']', '^', '"', '~', '*', '?', ':', '\\'), '', $filterKeywords);
```

### 第二处：SQL查询构建

找到构建SQL查询的部分：

```php
// 原始代码
if (!empty($filterKeywords)) {
    $filterKeywords = '%' . $filterKeywords . '%';
    $this->db->where('table.contents.title LIKE ? OR table.contents.text LIKE ?', $filterKeywords, $filterKeywords);
}
```

修改为：

```php
// 修改后的代码
if (!empty($filterKeywords)) {
    // 支持特殊符号的搜索
    $filterKeywords = '%' . addslashes($filterKeywords) . '%';
    $this->db->where('table.contents.title LIKE ? OR table.contents.text LIKE ?', $filterKeywords, $filterKeywords);
}
```

## 完整修改示例

```php
<?php
// var/Widget/Archive.php 修改示例

class Widget_Archive extends Widget_Abstract_Contents
{
    // ... 其他代码 ...
    
    /**
     * 执行搜索
     */
    public function search()
    {
        $this->db->select('table.contents.cid', 'table.contents.title', 'table.contents.slug', 'table.contents.created', 'table.contents.authorId', 'table.contents.modified', 'table.contents.type', 'table.contents.status', 'table.contents.password', 'table.contents.commentsNum', 'table.contents.order', 'table.contents.template', 'table.contents.allowComment', 'table.contents.allowPing', 'table.contents.allowFeed');
        $this->db->from('table.contents');
        
        // 获取搜索关键词
        $filterKeywords = $this->request->get('keywords');
        $filterKeywords = trim($filterKeywords);
        
        // 注释掉符号过滤，支持符号搜索
        // $filterKeywords = str_replace(array('+', '-', '&', '|', '!', '(', ')', '{', '}', '[', ']', '^', '"', '~', '*', '?', ':', '\\'), '', $filterKeywords);
        
        if (!empty($filterKeywords)) {
            // 使用addslashes防止SQL注入，同时支持符号搜索
            $filterKeywords = '%' . addslashes($filterKeywords) . '%';
            $this->db->where('table.contents.title LIKE ? OR table.contents.text LIKE ?', $filterKeywords, $filterKeywords);
        }
        
        // ... 其他搜索逻辑 ...
    }
}
```

## 安全注意事项

### 1. SQL注入防护

虽然我们允许符号搜索，但必须确保SQL安全：

```php
// 使用addslashes或更好的方法处理输入
$filterKeywords = addslashes($filterKeywords);

// 或者使用预处理语句
$stmt = $this->db->prepare('SELECT * FROM table.contents WHERE title LIKE ? OR text LIKE ?');
$stmt->execute(array($filterKeywords, $filterKeywords));
```

### 2. 输入验证

添加输入长度和内容验证：

```php
// 验证搜索关键词长度
if (strlen($filterKeywords) > 100) {
    $filterKeywords = substr($filterKeywords, 0, 100);
}

// 验证是否包含恶意内容
if (preg_match('/<script|javascript|vbscript|onload|onerror/i', $filterKeywords)) {
    $filterKeywords = '';
}
```

## 测试验证

### 1. 基本符号测试

测试以下符号是否能正常搜索：
- `+` 加号
- `-` 减号
- `&` 与号
- `|` 或号
- `!` 感叹号
- `()` 括号
- `[]` 方括号
- `{}` 花括号

### 2. 复杂搜索测试

测试复杂搜索表达式：
- `PHP + MySQL`
- `(前端|后端)开发`
- `ongwu & 插件`
- `[重要] 更新`

## 性能优化建议

### 1. 索引优化

为搜索字段添加数据库索引：

```sql
-- 为标题和内容字段添加全文索引
ALTER TABLE ongwu_contents ADD FULLTEXT(title, text);

-- 或者添加普通索引
CREATE INDEX idx_contents_title ON ongwu_contents(title);
CREATE INDEX idx_contents_text ON ongwu_contents(text);
```

### 2. 搜索结果缓存

实现搜索结果缓存机制：

```php
// 缓存搜索结果
$cacheKey = 'search_' . md5($filterKeywords);
$cachedResult = $this->cache->get($cacheKey);

if ($cachedResult !== false) {
    return $cachedResult;
}

// 执行搜索
$result = $this->performSearch($filterKeywords);

// 缓存结果
$this->cache->set($cacheKey, $result, 3600); // 缓存1小时

return $result;
```

## 兼容性考虑

### 1. 版本兼容

确保修改后的代码与ongwu版本兼容：

```php
// 检查ongwu版本
if (version_compare(ongwu_Common::VERSION, '1.2.0', '>=')) {
    // 新版本代码
} else {
    // 旧版本兼容代码
}
```

### 2. 插件兼容

如果使用了其他搜索相关插件，需要确保兼容性：

```php
// 检查是否有其他搜索插件
if (class_exists('Widget_Archive_Search')) {
    // 使用插件提供的搜索功能
    return $this->pluginSearch($filterKeywords);
}
```

## 总结

通过修改ongwu源码，我们可以实现符号搜索功能，但需要注意：

1. **安全性**：使用`addslashes`或预处理语句防止SQL注入
2. **性能**：添加适当的数据库索引和缓存机制
3. **兼容性**：确保与ongwu版本和其他插件的兼容性
4. **维护性**：记录修改内容，便于后续升级

这样修改后，ongwu就能支持包含符号的搜索了，满足更复杂的搜索需求。

---

*注意：修改源码后，在ongwu升级时需要重新应用这些修改。建议将修改内容记录在文档中，或者创建补丁文件。*

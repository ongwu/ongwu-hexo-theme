@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo ================================================
echo    Ongwu主题 + GitHub Pages + Hexo 一键搭建脚本
echo ================================================
echo ### 脚本作者: Ongwu
echo ### 作者网站: https://www.ongwu.cn
echo.
echo ------------------------------------------------------------------------
echo ### 安装前提示:
echo ### 脚本适用于所有windows系统，脚本会自动在本地机器安装 nodejs+Git 环境
echo ### 如已安装会忽略。
echo.
echo ### 安装 Hexo 会生成默认路径 "C:\ongwu" 此路径一定要保留!!!
echo ### 后续更新博客文章和推送 GitHub 会使用!!!
echo.
echo ### 请提前准备好 "GitHub Token", "GitHub用户名", "GitHub仓库地址" 信息
echo ### 怎么获取可以 Google~
echo ------------------------------------------------------------------------
echo.
pause
cls

REM 步骤1：检查并安装Node.js和Git
echo [1/3] 检查并安装Node.js和Git环境...

set node_installed=false
set git_installed=false
set refresh_env=false

where node >nul 2>nul && set node_installed=true
where git >nul 2>nul && set git_installed=true

if "!node_installed!"=="false" (
    echo 正在安装Node.js...
    powershell -Command "Invoke-WebRequest -Uri 'http://software.ongwu.cn/node.msi' -OutFile "$env:TEMP\node.msi""
    if exist "%TEMP%\node.msi" (
        msiexec /i "%TEMP%\node.msi" /quiet /norestart
        setx PATH "%PATH%;C:\Program Files\nodejs" /m
        set refresh_env=true
        echo Node.js安装完成，将继续安装Git（如果需要）
    ) else (
        echo 下载Node.js失败，请检查网络连接
        pause
        exit /b 1
    )
) else (
    echo Node.js已安装
)

if "!git_installed!"=="false" (
    echo 正在安装Git...
    powershell -Command "Invoke-WebRequest -Uri 'http://software.ongwu.cn/git.exe' -OutFile "$env:TEMP\git.exe""
    if exist "%TEMP%\git.exe" (
        start /wait "" "%TEMP%\git.exe" /SILENT
        setx PATH "%PATH%;C:\Program Files\Git\bin" /m
        set refresh_env=true
        echo Git安装完成，将继续后续步骤
    ) else (
        echo 下载Git失败，请检查网络连接
        pause
        exit /b 1
    )
) else (
    echo Git已安装
)

REM 如果有新安装的软件，刷新环境变量
if "!refresh_env!"=="true" (
    echo 正在刷新环境变量...
    for /f "skip=2 tokens=1,2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH') do (
        set sys_path=%%c
    )
    for /f "skip=2 tokens=1,2*" %%a in ('reg query "HKCU\Environment" /v PATH') do (
        set user_path=%%c
    )
    set PATH=!sys_path!;!user_path!
    echo 环境变量已刷新
)

echo.
echo 环境检查完成，按任意键继续...
pause
cls

REM 步骤2：创建ongwu目录并安装Hexo
echo [2/3] 创建C:\ongwu目录并安装Hexo...

if exist "C:\ongwu" (
    echo 已存在C:\ongwu目录，操作会删除重建C:\ongwu目录
    echo 按任意键继续或Ctrl+C取消...
    pause >nul
    rmdir /s /q "C:\ongwu" 2>nul
)

REM 创建目录并检查是否成功
mkdir "C:\ongwu" 2>nul
if not exist "C:\ongwu" (
    echo 创建目录失败，请检查权限
    echo 尝试使用管理员权限运行此脚本
    pause
    exit /b 1
)

REM 切换到目录并检查是否成功
cd /d "C:\ongwu" 2>nul
if errorlevel 1 (
    echo 无法切换到C:\ongwu目录，请检查权限
    pause
    exit /b 1
)

echo 成功创建并切换到C:\ongwu目录

:select_network
echo.
echo 请选择网络环境:
echo 国内网络环境安装请按"1"
echo 国外网络环境安装请按"2"
set /p network="请选择(1/2): "

if "!network!"=="1" (
    call npm config set registry https://registry.npmmirror.com
    echo 已设置为国内淘宝镜像源
) else if "!network!"=="2" (
    call npm config set registry https://registry.npmjs.org/
    echo 已设置为官方源
) else (
    echo 选择无效，请重新选择
    goto select_network
)

echo.
echo 正在安装hexo-cli...
call npm install -g hexo-cli
if errorlevel 1 (
    echo 安装hexo-cli失败，请检查网络连接
	echo hexo是从Github上拉取得 hexo是从Github上拉取得，我解决不了跨境问题  手动安装或者用国外网络吧
    echo 如果您选择了国内镜像源但连接失败，请尝试国外源
    pause
    exit /b 1
)

echo 正在初始化Hexo...
call hexo init .
if errorlevel 1 (
    echo 初始化Hexo失败 hexo是从Github上拉取得，我解决不了跨境问题  手动安装或者用国外网络吧
    pause
    exit /b 1
)

echo 正在安装依赖...
call npm install
call npm install hexo-deployer-git --save
if errorlevel 1 (
    echo 安装依赖失败
    pause
    exit /b 1
)

echo 正在拉取Ongwu主题...
call git clone https://github.com/ongwu/ongwu-hexo-theme.git
if errorlevel 1 (
    echo 拉取主题失败，请检查网络连接
    pause
    exit /b 1
)

echo 正在复制主题文件...
xcopy ongwu-hexo-theme\* . /E /Y /I /H >nul
if errorlevel 1 (
    echo 复制主题文件失败
    pause
    exit /b 1
)

echo 正在安装搜索插件...
call npm install hexo-generator-search --save
if errorlevel 1 (
    echo 安装搜索插件失败
    pause
    exit /b 1
)

echo 正在清理缓存...
call hexo clean

echo 正在生成博客...
call hexo g
if errorlevel 1 (
    echo 生成博客失败
    pause
    exit /b 1
)

echo 本地博客已启动，可通过 http://localhost:4000 访问
echo 按任意键继续部署到GitHub...
pause
cls

REM 步骤3：配置GitHub部署
echo [3/3] 配置GitHub部署...

set /p github_token=" 请输入GitHub Token: "
set /p github_username=" 请输入GitHub用户名: "
set /p github_repo=" 请输入 GitHub仓库地址 ( 格式为 xxxxx.github.io.git ): "

(
echo.
echo deploy:
echo   type: git
echo   repo: https://!github_username!:!github_token!@github.com/!github_username!/!github_repo!
echo   branch: main
) >> _config.yml

echo 正在推送到GitHub...
call hexo clean
call hexo g
call hexo d

echo.
echo ============================================================================================================================
echo 恭喜! 您的博客已部署到GitHub Pages, 博客根目录在 C:\ongwu 
echo 请访问: https://!github_username!.github.io
echo 后续更新文章可将 .md 文件放在 C:\ongwu\source\_posts 目录下 ，cmd进入C:\ongwu ，执行hexo clean 和 hexo g 和 hexo d 即可
echo 更多主题说明请访问 https://github.com/ongwu/ongwu-hexo-theme
echo ============================================================================================================================
echo.
echo 注意: 部署后需要1分钟~才能在GitHub上看到项目哦~~~,记得回来看看！https://www.ongwu.cn
pause
@echo off
setlocal enabledelayedexpansion

:: ANSI 颜色代码
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "RESET=[0m"

:: 预定义多个盘符和可能的路径
set drives=C D E F
set folderPath=\ST\STM32CubeIDE\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.win32_*
set CLTfolderPath=\ST\STM32CUbeCLT_*
set exeName=STM32_Programmer_CLI.exe
set foundPath=
set binPath=

:: 遍历所有盘符并查找 STM32_Programmer_CLI.exe
for %%d in (%drives%) do (
    for /d %%p in ("%%d:%CLTfolderPath%") do (
        if exist "%%p\STM32CubeProgrammer\bin\%exeName%" (
            set foundPath=%%p\STM32CubeProgrammer\bin\%exeName%
            goto foundCLI
        )
    )
    for /d %%p in ("%%d:%folderPath%") do (
        if exist "%%p\tools\bin\%exeName%" (
            set foundPath=%%p\tools\bin\%exeName%
            goto foundCLI
        )
    )
)

:: 未找到 CLI 工具，报错并退出
echo %RED%[ERROR]%RESET% STM32_Programmer_CLI.exe not found. Please install STM32CubeProgrammer.
echo %RED%[ERROR]%RESET% 操作失败！您的电脑未安装 STM32CubeIDE 软件，必须先安装才可以下载。
echo %RED%[ERROR]%RESET% 操作失败！您的电脑未安装 STM32CubeIDE 软件，必须先安装才可以下载。
echo %RED%[ERROR]%RESET% 操作失败！您的电脑未安装 STM32CubeIDE 软件，必须先安装才可以下载。
timeout /t 29
exit /b 1

:foundCLI
echo %GREEN%Found STM32_Programmer_CLI:%RESET% %foundPath%

:: 自动查找 bin 文件
if exist ".\build\Debug\*.bin" (
    for %%f in (.\build\Debug\*.bin) do (
        set binPath=%%~ff
        goto foundBin
    )
)

if exist ".\Debug\*.elf" (
    for %%f in (.\Debug\*.elf) do (
        set binPath=%%~ff
        goto foundBin
    )
)

:: 没找到 bin 文件，报错退出
echo %RED%[ERROR]%RESET% No bin file found in expected locations!
echo %RED%[ERROR]%RESET% 此工程文件不完整，请重新下载工程文档。（请不要在压缩包里打开，必须先解压缩再运行）
timeout /t 29
exit /b 1

:foundBin
echo %GREEN%Found BIN file:%RESET% %binPath%

:: 下载 bin 文件到 Flash
echo %YELLOW%Flashing STM32 firmware...%RESET%
"%foundPath%" -c port=SWD -w "%binPath%" 0x08000000
if %errorlevel% neq 0 (
    echo %RED%[ERROR]%RESET% Flash programming failed!
    pause
    exit /b 1
)

:: 发送复位命令
echo %YELLOW%Flash programming successful. Resetting STM32...%RESET%
"%foundPath%" -c port=SWD -rst
if %errorlevel% neq 0 (
    echo %RED%[ERROR]%RESET% Failed to reset STM32!
    pause
    exit /b 1
)

:: 高亮成功信息
echo %GREEN%STM32 successfully programmed and reset! [0m
:: 换行
echo.
echo %GREEN%下载成功！！ [0m
timeout /t 15
exit



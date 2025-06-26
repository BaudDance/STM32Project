@echo off
setlocal enabledelayedexpansion

:: ANSI ��ɫ����
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "RESET=[0m"

:: Ԥ�������̷��Ϳ��ܵ�·��
set drives=C D E F
set folderPath=\ST\STM32CubeIDE\STM32CubeIDE\plugins\com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.win32_*
set CLTfolderPath=\ST\STM32CUbeCLT_*
set exeName=STM32_Programmer_CLI.exe
set foundPath=
set binPath=

:: ���������̷������� STM32_Programmer_CLI.exe
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

:: δ�ҵ� CLI ���ߣ������˳�
echo %RED%[ERROR]%RESET% STM32_Programmer_CLI.exe not found. Please install STM32CubeProgrammer.
echo %RED%[ERROR]%RESET% ����ʧ�ܣ����ĵ���δ��װ STM32CubeIDE ����������Ȱ�װ�ſ������ء�
echo %RED%[ERROR]%RESET% ����ʧ�ܣ����ĵ���δ��װ STM32CubeIDE ����������Ȱ�װ�ſ������ء�
echo %RED%[ERROR]%RESET% ����ʧ�ܣ����ĵ���δ��װ STM32CubeIDE ����������Ȱ�װ�ſ������ء�
timeout /t 29
exit /b 1

:foundCLI
echo %GREEN%Found STM32_Programmer_CLI:%RESET% %foundPath%

:: �Զ����� bin �ļ�
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

:: û�ҵ� bin �ļ��������˳�
echo %RED%[ERROR]%RESET% No bin file found in expected locations!
echo %RED%[ERROR]%RESET% �˹����ļ������������������ع����ĵ������벻Ҫ��ѹ������򿪣������Ƚ�ѹ�������У�
timeout /t 29
exit /b 1

:foundBin
echo %GREEN%Found BIN file:%RESET% %binPath%

:: ���� bin �ļ��� Flash
echo %YELLOW%Flashing STM32 firmware...%RESET%
"%foundPath%" -c port=SWD -w "%binPath%" 0x08000000
if %errorlevel% neq 0 (
    echo %RED%[ERROR]%RESET% Flash programming failed!
    pause
    exit /b 1
)

:: ���͸�λ����
echo %YELLOW%Flash programming successful. Resetting STM32...%RESET%
"%foundPath%" -c port=SWD -rst
if %errorlevel% neq 0 (
    echo %RED%[ERROR]%RESET% Failed to reset STM32!
    pause
    exit /b 1
)

:: �����ɹ���Ϣ
echo %GREEN%STM32 successfully programmed and reset! [0m
:: ����
echo.
echo %GREEN%���سɹ����� [0m
timeout /t 15
exit



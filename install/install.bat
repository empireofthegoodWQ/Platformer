@echo off
chcp 65001 > nul
echo  ================================
call :output 02 "INSTALLER"
echo  ================================

set "GAME_NAME=Platformer"
set "BAT_PATH=%~dp0"
set "ROOT=%BAT_PATH%..\.."
set "PYI_FLAGS=--noconfirm --onedir --windowed"

:: Проверка есть ли пайтон в системе
python --version 1>nul 2>&1 || (
	call :output 04 "Пайтон не установлен!"
	echo Установите его по инструкции https://metanit.com/python/tutorial/1.2.php.
	pause
	exit /b
)

:: Настройка виртуального окружения
dir /ad "%BAT_PATH%venv" > nul 2>&1 || (
	echo Cоздание виртуального окружения
	python -m venv "%BAT_PATH%venv"
)
call "%BAT_PATH%venv\Scripts\activate.bat"

cd /d "%ROOT%\."
echo Обновление pip..
python -m pip install --upgrade pip > nul || call :output 04 "[ERROR] Не удалось обновить pip"
echo Установка основных зависимостей
pip install -r "%ROOT%\requirements.txt" > nul 

:: Сборка в .ЕХЕ и копирование ресурсов в релизную папку
call :output 03 "Компиляция игры..."
pyinstaller %PYI_FLAGS% --name "%GAME_NAME%" --distpath "%BAT_PATH%." main.py || (pause && exit /b)

echo Копирование картинок и настроек в папку с игрой...
copy /Y "%ROOT%\*.json" "%BAT_PATH%%GAME_NAME%" > nul
xcopy /E /I /Y "%ROOT%\assets" "%BAT_PATH%%GAME_NAME%\assets" > nul

call :output 01 "Сборка завершена."
call :output 02 "Путь к файлу ""%BAT_PATH%%GAME_NAME%"""
pause
exit /b

:output 
:: num_color text
color %1
echo %~2
color 07
goto :eof

@echo off
chcp 65001 > nul
echo ==============================================
echo [Game] Начинаем установку и сборку игры...
echo ==============================================

cd ..
set "PROJECT_ROOT=%CD%"

if not exist venv (
    echo [1/5] Создаем виртуальное окружение...
    python -m venv venv
) else (
    echo [1/5] Виртуальное окружение уже существует.
)

echo [2/5] Активация окружения...
call venv\Scripts\activate.bat

echo [3/5] Обновление pip и установка зависимостей...
python -m pip install --upgrade pip
pip install -r requirements.txt
pip install pyinstaller

echo [4/5] Компиляция игры в .EXE...
pyinstaller --noconfirm --onedir --windowed --name "Game" main.py

echo [5/5] Копирование ресурсов...
:: Папки с картинками/звуками
if exist assets xcopy /E /I /Y assets dist\Game\assets > nul
if exist sounds xcopy /E /I /Y sounds dist\Game\sounds > nul
if exist images xcopy /E /I /Y images dist\Game\images > nul

:: JSON файлы уровней (важно!)
if exist levels.json copy /Y levels.json dist\Game\levels.json > nul
if exist data\*.json xcopy /E /I /Y data\*.json dist\Game\data\ > nul 2> nul

echo ==============================================
echo [УСПЕХ] Сборка завершена!
echo.
echo Готовая игра: %PROJECT_ROOT%\dist\Game\Game.exe
echo Уровни скопированы: %PROJECT_ROOT%\dist\Game\levels.json
echo.
echo Запускайте и наслаждайтесь!
echo ==============================================
pause

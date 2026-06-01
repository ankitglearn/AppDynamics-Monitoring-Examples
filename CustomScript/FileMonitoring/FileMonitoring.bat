@echo off
setlocal enabledelayedexpansion
 
:: Get today's date using PowerShell
for /f %%i in ('powershell -Command "(Get-Date).ToString('yyyy-MM-dd')"') do set "today=%%i"
 
:: Split into year, month, day
for /f "tokens=1-3 delims=-" %%a in ("%today%") do (
    set "year=%%a"
    set "month=%%b"
    set "day=%%c"
)
 
:: Build folder path
set "folderPath=E:\IM_Archives\%year%\%month%\%day%"
echo Checking folder: %folderPath%
 
:: Initialize default metric value
set "metricValue=0"
 
:: Check if folder exists
if exist "%folderPath%" (
    dir /b "%folderPath%\*.html" >nul 2>&1
    if %errorlevel%==0 (
        set "metricValue=1"
    )
    dir /b "%folderPath%\*.zip" >nul 2>&1
    if %errorlevel%==0 (
        set "metricValue=1"
    )
) else (
    set "metricValue=-1"
)
 
:: Output for AppDynamics
echo name=Custom Metrics^|FileMonitor^|DailyHTMLZipMonitor^|FileArrivedToday,value=!metricValue!
 
exit /b 0
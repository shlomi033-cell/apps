@echo off
setlocal
rem Usage: publish.bat <Name> <Version> <file> [more files...]
rem Uploads to release <Name>-latest in shlomi033-cell/apps, replacing old files.
rem .exe is renamed to <Name>-Setup.exe and .apk to <Name>.apk so site links never change.
if "%~3"=="" (echo Usage: publish.bat Name Version file [files...] & exit /b 1)
set "NAME=%~1"
set "VER=%~2"
set "TAG=%~1-latest"
set "R=shlomi033-cell/apps"
where gh >nul 2>nul || (echo gh is not installed - not publishing. & exit /b 0)
choice /m "Publish %NAME% %VER% to the download site"
if errorlevel 2 exit /b 0
set "T=%TEMP%\apps-publish-%NAME%"
if exist "%T%" rmdir /s /q "%T%"
mkdir "%T%"
shift
shift
:next
if "%~1"=="" goto upload
if not exist "%~1" (echo Missing file: %~1 & goto fail)
if /i "%~x1"==".exe" (copy /y "%~1" "%T%\%NAME%-Setup.exe" >nul) else if /i "%~x1"==".apk" (copy /y "%~1" "%T%\%NAME%.apk" >nul) else (copy /y "%~1" "%T%\" >nul)
shift
goto next
:upload
gh release view %TAG% -R %R% >nul 2>nul || gh release create %TAG% -R %R% --title "%NAME% %VER%" --notes "%NAME% %VER%" --latest=false || goto fail
for %%f in ("%T%\*") do (
  echo Uploading %%~nxf ...
  gh release upload %TAG% -R %R% --clobber "%%f" || goto fail
)
gh release edit %TAG% -R %R% --title "%NAME% %VER%" --notes "%NAME% %VER%" >nul || goto fail
rmdir /s /q "%T%"
echo Published %NAME% %VER%: https://shlomi033-cell.github.io/apps/
exit /b 0
:fail
echo PUBLISH FAILED - send a screenshot of this window.
exit /b 1

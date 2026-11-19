@echo off
rem Uploads the download site (index.html + icons) to GitHub Pages.
cd /d "%~dp0"
where git >nul 2>nul || (echo Git is missing. Install it with:  winget install Git.Git  then run this again. & pause & exit /b 1)
gh auth setup-git >nul 2>nul
if not exist .git (
  git init -q -b main
  git remote add origin https://github.com/shlomi033-cell/apps.git
)
git config user.email >nul 2>nul || git config user.email "shlomi033-cell@users.noreply.github.com"
git config user.name >nul 2>nul || git config user.name "shlomi033-cell"
git add -A
git commit -q -m "Update site"
git pull -q --no-rebase --allow-unrelated-histories --no-edit origin main
git push -u origin main || (echo PUSH FAILED - send a screenshot of this window. & pause & exit /b 1)
echo.
echo DONE. In 1-2 minutes the site is live: https://shlomi033-cell.github.io/apps/
pause

@echo off
cd /d "%~dp0"
set GIT_PAGER=cat
if exist my-commit-repo (
  echo Folder my-commit-repo already exists. Delete it and run again.
  pause
  exit /b 1
)
echo ===== 1. Prepare repository =====
git init my-commit-repo
cd my-commit-repo
git config user.name >nul 2>&1 || git config user.name "Student"
git config user.email >nul 2>&1 || git config user.email "student@example.com"
echo # My Commit Repo> README.md
git add README.md
git commit -m "Initial commit with README"
echo.
echo *** Make a screenshot, then press any key
pause >nul

echo ===== 2. Create commits =====
copy /y ..\assets\index_v1.html index.html >nul
git add index.html
git commit -m "Add basic index.html file"
git status
echo.
echo *** Make a screenshot, then press any key
pause >nul
copy /y ..\assets\style.css style.css >nul
git add style.css
git commit -m "Add basic styles for the project"
echo.
echo *** Make a screenshot, then press any key
pause >nul

echo ===== 3. Commit history =====
git log --oneline
git log
git show HEAD~1
echo.
echo *** Make a screenshot, then press any key
pause >nul

echo ===== 4a. Amend last commit =====
copy /y ..\assets\index_v2.html index.html >nul
git add index.html
git commit --amend -m "Updated index.html with thank you message"
git log --oneline
echo.
echo *** Make a screenshot, then press any key
pause >nul

echo ===== 4b. Reset =====
echo This is an error file> error.txt
git add error.txt
git commit -m "Mistakenly added error.txt"
git log --oneline
echo.
echo *** Make a screenshot, then press any key
pause >nul
git reset HEAD~1
git status
echo.
echo *** Make a screenshot, then press any key
pause >nul
del error.txt
git add .
git diff --cached --quiet || git commit -m "Removed mistakenly added error.txt"
git status
echo.
echo *** Make a screenshot, then press any key
pause >nul

echo ===== 5. Restore files =====
echo ^<h1^>About Us^</h1^>> about.html
git add about.html
git commit -m "Added about.html file"
del about.html
git rm about.html
git commit -m "Deleted about.html"
git checkout HEAD~1 about.html
dir
git add about.html
git commit -m "Restored about.html file"
echo.
echo *** Make a screenshot, then press any key
pause >nul

git log --oneline --graph
echo.
echo DONE! Open my-commit-repo\index.html in the browser.
pause

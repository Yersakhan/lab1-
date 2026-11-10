#!/usr/bin/env bash
# Автоматическое выполнение лабораторной работы "Работа с коммитами в Git"
# Запуск:  bash run_lab.sh        (с паузами для скриншотов)
#          bash run_lab.sh --auto (без пауз)
set -e
export GIT_PAGER=cat
export PAGER=cat
HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$HERE/my-commit-repo"
AUTO=0; [ "$1" = "--auto" ] && AUTO=1

step(){ echo; echo "=================================================="; echo "  $1"; echo "=================================================="; }
run(){ echo "\$ $*"; "$@"; }
pause(){ [ $AUTO -eq 1 ] || read -r -p ">>> Сделайте скриншот, затем нажмите Enter..." _; }

if [ -d "$REPO" ]; then
  echo "Папка my-commit-repo уже существует. Удалите или переименуйте её и запустите снова."; exit 1
fi
cd "$HERE"

step "1. Подготовка репозитория"
run git init my-commit-repo
cd "$REPO"
git config user.name  >/dev/null || git config user.name  "Student"
git config user.email >/dev/null || git config user.email "student@example.com"
echo "# My Commit Repo" > README.md
run git add README.md
run git commit -m "Initial commit with README"
pause

step "2. Создание коммитов"
cp "$HERE/assets/index_v1.html" index.html
run git add index.html
run git commit -m "Add basic index.html file"
run git status
pause
cp "$HERE/assets/style.css" style.css
run git add style.css
run git commit -m "Add basic styles for the project"
pause

step "3. Просмотр истории коммитов"
run git log --oneline
run git log
run git show "$(git rev-parse --short HEAD~1)"
pause

step "4a. Изменение последнего коммита (--amend)"
cp "$HERE/assets/index_v2.html" index.html
run git add index.html
run git commit --amend -m "Updated index.html with thank you message"
run git log --oneline
pause

step "4b. Откат изменений (reset)"
echo "This is an error file" > error.txt
run git add error.txt
run git commit -m "Mistakenly added error.txt"
run git log --oneline
pause
run git reset HEAD^
run git status
pause
run rm error.txt
run git add .
if git diff --cached --quiet; then
  echo "(Нечего коммитить: после reset файл error.txt был неотслеживаемым, а после rm рабочая папка чистая.)"
else
  run git commit -m "Removed mistakenly added error.txt"
fi
pause

step "5. Восстановление файлов"
echo "<h1>About Us</h1>" > about.html
run git add about.html
run git commit -m "Added about.html file"
run rm about.html
run git rm about.html
run git commit -m "Deleted about.html"
run git checkout HEAD^ about.html
run ls
run git add about.html
run git commit -m "Restored about.html file"
pause

step "Итоговая история"
run git log --oneline --graph

echo
echo "ГОТОВО! Репозиторий: $REPO"
echo "Откройте my-commit-repo/index.html в браузере, чтобы увидеть сайт."

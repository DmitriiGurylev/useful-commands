# GIT-comands

git init - создание папки .git;
git clone [url] - клонирование репозитория;
git clone [url] *name* - клонирование репозитория и присваивание имени name;
git status - определение состояниф файлов;
git add *file* - делает файл отслеживаемым (файлы через пробел);
cat .gitignore - игнорирвоание файлов;
git diff - подробная команда, выводящая добавленные и удаленные файлы;
git commit - фиксация изменений; 
git commit -m - фиксация изменений и комментарий коммита;
git commit -a - фиксация изменений + команда git add;
git rm *file* - удаление файла из отслеживаемых и репозитория;
git rm *file* -f - принудительно;
git rm --cached *file* - удаление файла из отслеживаемых, сохранение его в репозитории;
git mv *file_first* *file_second* - переименовать файл;
git log - просмотр истории версий;
git log -p - просмотр истории версий c разницей между коммитами;
git log -3(-2) - просмотр истории 3(2) последних версий;
git log -stat - показывает измененные файлы;
git log --author=*author_name* - просмотр истории коммитов определнного автора;
git commit --amend - повторное сохранение предыдущего коммита;
git reset HEAD *file* - отмена индексированного файла;
git checkout -- *file* - возвращает файл к состоянию предыдущего коммита;
git remote - показывает удаленные сервера;
git remote -v - показывает удаленные сервера с URL-ссылками;
git fetch *remote_server* - извлечение данных из удаленного репозитория;
git pull - извлечение данных с ветки и слияние с текущей локальной веткой;
git push *remote_server* *remote_branch* - указывает ветку, куда пушить;
git push *remote_server* --delete *remote_branch* - удалить ветку на сервере;
git push *remote_server* *local_branch*:*remote_branch* - запушить локальную ветку в удаленную ветку на удаленный сервер;
git remote show *remote_server* - показывает информацию о конкретном сервере;
git config --global alias.*alias* *command* - создание псевдонима alias для команды command;
git config --global alias.br branch;
git config --global alias.co checkout;
git config --global alias.ci commit;
git config --global alias.st status;
git branch *local_branch* - создание новой ветки;
git checkout *local_branch* - переход на ветку name;
git checkout -b *local_branch* - создание новой ветки и переход на нее;
git checkout -b *local_branch* *remote_server*/*remote_branch* - создание новой ветки на основе удаленной ветки и переход на нее;
git checkout --track *remote_server*/*remote_branch* - создание новой ветки, отслеживающей удаленную ветку;
git merge *remote_branch* - объединение веток (HEAD должна быть на главной ветке);
git branch -d *name* - удаление ветки;
(merge commit - когда у коммита несколько предков)
(fast-forward - перемотка)
(tracking branch - ветка наблюдения)
(rebasing - перемещение)
git mergetool - графический интерфейс;
git bracnh -v - показывает последний коммит в каждой ветке;
git config --global credential.helper cache (или store) - хранение логина/пароля в кэшэ в течение определенного времени или на диске;
git branch -u *remote_server*/*remote_branch* - сопоставить текущую локальную ветку удаленной ветке;
git branch -vv - список веток наблюдения;
git rebase *local_branch* - переместить изменения текущей ветки в конец указанной ветки
git rebase *local_branch_1* *local_branch_2* - переключает на 2ую ветку и воспроизводит ее содержимое в 1ой ветке
git rebase --onto *local_branch_1* *local_branch_2* *local_branch_3* - переместить изменения 3 ветки в 1ую


пушить в packages registry git
publishing {
    publications {
        mavenJava(MavenPublication) {
            groupId "xx.xxxxxx"
            artifactId "yyyyyyyyyyyyyyyyyyy"
            version "1.0.0"
            from components.java
        }
    }
    repositories {
        maven {
            name "gitlab"
            url "http://gitlab.zzzzzzzzzzzzzzzzz/api/v4/projects/*project_id*/packages/maven"
            allowInsecureProtocol true
            credentials(HttpHeaderCredentials) {
                name = "Private-Token"
                value = "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
            }
            authentication {
                header(HttpHeaderAuthentication)
            }
        }
    }
}
так удалять
curl --request DELETE --header "PRIVATE-TOKEN: vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv" "http://gitlab.zzzzzzzzzzzzzzzzz/api/v4/projects/*project_id*/packages/fff"


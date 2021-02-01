# docker-laravel
Gotowe środowisko dockera pod projekty Laravela. Wykorzystuje stos LEMP (Linux, Nginx, MySQL, PHP). 

**Źródło:** https://dev.to/aschmelyun/the-beauty-of-docker-for-local-laravel-development-13c0


## Opis instalacji

**Modyfikacje:**

	- Dodany composer do usługi php - patrz poniżej: sekcja Uwagi.
	- Dodane dodatkowe pakiety Alpine Linux (GIT).

**Wymagania:** zainstalowany **[Docker](https://docs.docker.com/docker-for-mac/install/)** i **[Docker Compose](https://docs.docker.com/compose/install/)**, **[Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)**.

- Utwórz folder na projekt np **laravel-app**: `mkdir ~/projects/laravel-app`

- do folderu z projektem sklonuj repozytorium z https://github.com/aschmelyun/docker-compose-laravel:

  `git clone https://github.com/aschmelyun/docker-compose-laravel .`

- Po sklonowaniu repozytorium zostanie utworzony m.in. folder **src** `~/projects/laravel-app/src`. Do tego folderu przenieś swój projekt Laravela. Jeśli tworzysz nowy projekt, pobierz go np. **composerem**:

  - W tym celu przejdź do folderu **src**: `cd ~/projects/laravel-app/src`

  - Tworzymy nowy projekt Laravela w bieżącym folderze: `composer create-project laravel/laravel .`

  - Po utworzeniu projektu za pomocą composera, możemy w tym momenie wyedytować plik **.env**: `nano ~/projects/laravel-app/src/.env`, aby ustawić dostęp do bazy danych, czy adres URL projektu (dane dostępowe, jakie utworzyliśmy w pliku dockera `~/projects/laravel-app/docker-compose.yml`). 

    W tym przykładzie - w pliku **~/projects/laravel-app/src/.env** ustawiamy wartości:

    ```
    DB_CONNECTION=mysql
    DB_HOST=mysql
    DB_PORT=3306
    DB_DATABASE=homestead
    DB_USERNAME=homestead
    DB_PASSWORD=secret
    ```

    oraz adres URL projektu:

    ```
    APP_URL=http://localhost:8080
    ```


Uworzenie obrazów dla wszystkich usług opisanych w pliku **app/docker-compose.yml**:

- `docker-compose build`

Uruchomienie wszystkich aplikacji w tle:

- `docker-compose up -d`
  
  ![screenshot docker compose up](https://melma.pl/shared/git_projects/docker_laravel/docker_compose_up.png)

Sprawdźmy utworzone kontenery:

- `docker ps`

  ![screenshot docker ps](https://melma.pl/shared/git_projects/docker_laravel/docker_ps.png)


Możemy jeszcze sprawdzić logi dockera:

- `docker-compose logs -f`

Zatrzymanie kontenerów i usunięcie sieci:

- `docker-compose down`



## Laravel - migracje i rozbudowa

W pliku `~/projects/laravel-app/docker-compose.yml` skonfigurowaliśmy 3 dodatkowe kontenery (**composer**, **artisan**, **npm**).



**Composer:**

Przechodzimy do folderu z projektem: `cd ~/projects/laravel-app`.

Sprawdźmy wersję zainstalowanego composera:

- Sprawdzamy wersję composera za pomocą polecenia: `docker-compose run --rm composer --version`

Aktualizacja rozszerzeń aplikacji Laravela zawartych w pliku src/composer.json:

- `docker-compose run --rm composer update`

Przykład instalacji rozszerzenia Laravela - Laravel Debugbar (https://github.com/barryvdh/laravel-debugbar):

- `docker-compose run --rm composer require barryvdh/laravel-debugbar --dev`

**Uwaga**: użycie composera w sposób opisany powyżej powoduje błędy spowodowane niewłaściwymi uprawnieniami. Dodałem instalację composera do usługi **php** (**php.dockerfile**) - patrz poniżej: sekcja **Uwagi**.



**Migracje:**

Przechodzimy do folderu z projektem: `cd ~/projects/laravel-app`.

- Wykonanie migracji: `docker-compose run --rm artisan migrate`
  
  ![screenshot artisan migrate](https://melma.pl/shared/git_projects/docker_laravel/artisan_migrate.png)
- Wylistowanie statusów wszystkich migracji aplikacji Laravela: `docker-compose run --rm artisan migrate:status` 
  
  ![screenshot artisan migrate status](https://melma.pl/shared/git_projects/docker_laravel/artisan_migrate_status.png)



**NPM:**

Przechodzimy do folderu z projektem: `cd ~/projects/laravel-app`.

- Uruchomienie npm: `docker-compose run --rm npm run dev`



## Przydatne rozszerzenia Laravela

- **Instalacja panelu administracyjnego Voyager (https://github.com/the-control-group/voyager):**

  - Pobieramy paczkę composerem:

    `docker-compose run --rm composer require tcg/voyager`

    ![screenshot composer require voyager](https://melma.pl/shared/git_projects/docker_laravel/composer_require_voyager.png)

  - Instalujemy voyagera z przykładowymi danymi:

    `php artisan voyager:install --with-dummy`

    ![screenshot composer install voyager](https://melma.pl/shared/git_projects/docker_laravel/composer_install_voyager_1.png)
    
    Voyager został zainstalowany:

    ![screenshot composer install voyager](https://melma.pl/shared/git_projects/docker_laravel/composer_install_voyager_2.png)



## Przydatne komendy

**Informacyjne:**

- `docker container ls -a` - wyświetla listę wszystkich istniejących kontenerów Dockera
- `docker images ls` - wyświetla listę wszystkich istniejących obrazów Dockera
- `docker volume ls` - wyświetla listę wszystkich istniejących wolumenów Dockera
- `docker network ls` - wyświetla listę wszystkich istniejących sieci Dockera



**Monitoring Dockera:**

- `docker logs -f [container_id]` - wyświetla wszystkie logi wygenerowane w uruchomionym kontenerze Dockera o podanym ID (**[container_id]**). Parametr `-f` wyświetla logi w czasie rzeczywistym
- `docker top [container_id]` - wyświetlanie statystyk o procesach, obciążeniu serwera wewnątrz kontenera Dockera o danym ID (**[container_id]**)
- `docker stats [container_id]` - sprawdzenie stanu zużycia zasobów serwera wewnątrz kontenera Dockera o danym ID (**[container_id]**)



**Zatrzymywanie i usuwanie obiektów Dockera:**

- `docker container stop [container_id]` - zatrzymanie kontenera o podanym ID (**[container_id]**)
- `docker container rm [container_id]` - usunięcie zatrzymanego kontenera Dockera o podanym ID (**[container_id]**)
- `docker container rm $(docker container ls –aq)` - usunięcie wszystkich zatrzymanych kontenerów Dockera o podanym ID (**[container_id]**)
- `docker container stop $(docker container ls –aq) && docker system prune –af ––volumes` - usunięcie wszystkich kontenerów Dockera
- `docker image rm [image_id1] [image_id2]` - usunięcie obrazów Dockera o podanym ID (**[image_id1]**, **[image_id2]**)
- `docker volume rm [volume_name]` - usunięcie wolumenu Dockera o danej nazwie (**[volume_name]**)
- `docker network rm [network_id]` - usunięcie sieci Dockera o danym ID (**[network_id]**)
- `docker system prune` - czyszczenie systemu z nieużywanych kontenerów, obrazów, wolumenów i innych używanych przez Dockera zasobów
- `docker container prune` - usunięcie wszystkich kontenerów Dockera
- `docker image prune` - usunięcie wszystkich obrazów Dockera
- `docker volume prune` - usunięcie wszystkich wolumenów Dockera
- `docker network prune` - usunięcie wszystkich sieci Dockera
- `docker-compose up` - uruchomienie kontenerów
- `docker-compose stop` - zatrzymanie kontenerów



**Przesyłanie komend do kontenera:**

- `docker exec -it [container_id] [command]` - wykonanie komendy (**[command]**) wewnątrz kontenera Dockera o danym ID (**[container_id]**). Parametry `-it` oznaczają tryb interakwtywny i zwrócenie na ekran odpowiedzi serwera z danego kontenera
- `docker exec -it [container_id] sh` - uruchomienie powłoki shell wewnątrz kontenera Dockera o danym ID (**[container_id]**)



## Uwagi

- Do php.dockerfile dodałem instalację composera, ponieważ użycie composera z kontenera composer powodowało błędy podczas instalacji dodatków Laravela. Z composera korzystamy po wejściu do kontenera php. Przykład:

  - `docker exec -it php sh` - przechodzimy do kontenera **php**
    
    ![screenshot docker exec php](https://melma.pl/shared/git_projects/docker_laravel/docker_exec_php.png)
  - `composer update` - uruchomienie **composer update** wewnątrz kontenera **php**
    
    ![screenshot composer update](https://melma.pl/shared/git_projects/docker_laravel/composer_update.png)
  - `composer require barryvdh/laravel-debugbar --dev` - za pomocą composera instalujemy np. Laravel Debugbar
    
    ![screenshot composer install Laravel Debugbar](https://melma.pl/shared/git_projects/docker_laravel/composer_install_laravel_debugbar.png)

  Dopóki nie zostanie naprawiony problem z composerem z osobnego kontenera, nie wykonujemy poleceń w postaci: `docker-compose run --rm composer update`, tylko w opisany powyżej sposób.




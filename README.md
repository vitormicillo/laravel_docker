****
# ABOUT THE PROJECT
- A complete docker environment to work with Laravel or Lumen.
- This initial structure is excellent for developing a SPA Laravel API
- All commands used were tested using Ubuntu/Debian and OpenSuse Tumbleweed.
- Any PR are welcome

<br>

# STRUCTURE
 * [Laravel 9](https://laravel.com)
 * [nginx:alpine](https://hub.docker.com/_/nginx) - [versions](https://nginx.org/en/CHANGES)
 * [php:8.1.0-fpm](https://hub.docker.com/_/php)
 * [redis:alpine](https://hub.docker.com/_/redis)
 * [phpmyadmin:latest](https://hub.docker.com/_/phpmyadmin)
 * [Mysql 5.7.22](https://hub.docker.com/_/mysql)
 * [Node 18](https://github.com/nodesource/distributions#debmanual)
 * [Yarn](https://https://yarnpkg.com/)
 * [Mail Hog](https://github.com/mailhog/MailHog)

<br>

**🔔 Notes:** 
- These below commands are tested with Linux Ubuntu/Debian and OpenSuse Tumbleweed, for Windows is necessary to have WSL
- Is up to you to rename your project folder name
- On your file **docker-compose** the parameters  **DB_HOST**, **CACHE_DRIVER**, **REDIS_HOST** must have the same name as your container.
Docker automatically references and identifies the IP of the container and adds it to the environment variable of the .env, so it's enough to just put the container name instead of the ip.

<br>

# STEP BY STEP

Clone the repository
```sh
git clone https://github.com/vitormicillo/laravel_docker.git
```

You can clone Laravel repository from github in case you don't want to install **composer package manager** on your local system

```sh
git clone https://github.com/laravel/laravel.git example-project
``` 
or using **composer** to install 

```sh
composer create-project laravel/laravel my-application-name
```
----
#### Copy "docker-compose.yml", "Dockerfile" and the "docker folder" to your project.
----

Cloning the .env file environment
```sh
cp .env.example .env
```

----
### Let's deploy the container
----

```sh
docker-compose up -d
```
----
### 🔔 Note:
When all containers are finished and properly configured 🤙🏻, you will be able to see the list of containers and details with the command:

```sh
docker images

# Command output should looks like 👇🏻
```

| REPOSITORY 					| TAG 	 | IMAGE ID 	| CREATED 		 | SIZE |
| ----------------------------- | ------ | ------------ | -------------- | ----- |
| laravel-example-project-queue | latest | 475c83b2168a | 33 minutes ago | 791MB |
| app 							| latest | 475c83b2168a | 33 minutes ago | 791MB |
| redis							| latest | dc7b40a0b05d | 12 days ago 	 | 791MB |
| nginx 						| alpine | 475c83b2168a | 3 weeks ago 	 | 791MB |
| phpmyadmin/phpmyadmin 		| latest | 475c83b2168a | 3 mmonths ago  | 791MB |
| mailhog/mailhog 				| latest | 4de68494cd0d | 2 years ago 	 | 791MB |
| mysql 						| 5.7.22 | 4a4023c7e22a | 4 years ago 	 | 791MB |
----

<br>

----
### To access the container bash
```sh
docker-compose exec app bash
```
----
### Run the following commands
----
```sh
composer install

php artisan key:generate

php artisan config:cache

php artisan storage:link #Not mandatory

npm or yarn install #Not mandatory
```

- To access your application  http://localhost:8180
- To access the phpmyadmin http://localhost:8181
- To acces the e-mail server http://localhost:8100/

<br>

**🔔 Note:**
- Don't forget to add the file **.gitignore** to the folder **/docker/mysql/*** 
- if you get an error when you try to build the application with **docker-compose up -d --build**  
  check if the folder **docker/mysql/dbdata** has the correct permission 644 and is not protected to write, update or delete.
- Run this command inside the folder **docker/mysql/**

```sh
  chmod -R 644 dbdata
  "if it doesn't work use" chmod -Rf 777 dbdata
```

<br>

## ⭐️ SOME CUSTOM CHANGES YOU CAN DO
Changing the ports on docker-compose file.

for example, from port 8181

```sh
ports:
    - 8181:80
```
to port 8182
```sh
ports:
    - 8182:80
```

In the docker-compose you are able to change the network name according to the name of your project, to make it easier to identify the current project you are working on.
```sh
networks:
    - my-application-name
```

Changing the container name from:

```sh
 container_name: name-1
```
to:
```sh
 container_name: my-application-name
```

Changing the service name
```sh
services from:
    # project
    app:
        container_name: my-application-name
        build:
```        
to:
```sh
services:
    # project
    my-application-name:
        container_name: my-application-name
        build:
```  

Make sure you read the entire document and you change your app's name to the new name.

Note: Update the file docker/nginx/laravel.conf
```sh
fastcgi_pass app:9000;
```
to
```sh
fastcgi_pass my-application-name:9000;
```

## DOCKER HELPFUL COMMANDS

Stop all containers
```sh
docker stop $(docker ps -qa)
```

To remove all containers
```sh
docker rm $(docker ps -qa)
```

To remove all images
```sh
docker rmi $(docker images -qa)
```

To remove any specific image
```sh
docker rmi -f image_code
```

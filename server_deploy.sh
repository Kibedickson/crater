#!/bin/sh
set -e

echo " Deploying Application... "

# Enter Maintenance Mode
(docker-compose exec -it app php artisan down --message 'The app is being (quickly!) updated. Please try again in a minute.') || true
  # update Codebase
  git fetch origin deploy
  git reset --hard origin/deploy

  docker-compose up -d --build

  # Install dependencies based on composer.lock file
  docker-compose exec -it app composer install --no-interaction --prefer-dist --optimize-autoloader --ignore-platform-reqs

  # Migrate database
  docker-compose exec -it app php artisan migrate --force

  # Stop Cronjob

  # Clear Cache
  docker-compose exec -it app php artisan config:clear
  docker-compose exec -it app php artisan cache:clear

# Exit Maintenance Mode
docker-compose exec -it app php artisan up


echo " Application Deployed ! "
FROM php:8.1.0-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
	build-essential \
	make \
	gcc \
	g++

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# To change node LTS version path
# https://github.com/nodesource/distributions#debmanual
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update && apt-get install -y nodejs && npm install --global yarn

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user

RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Install redis
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

# Main folder after accessing the container
WORKDIR /var/www

# Remove html folder
RUN rm -rf /var/www/html

# Expose port 900 to start php-fpm server
EXPOSE 9000

#RUN npm install
USER $user

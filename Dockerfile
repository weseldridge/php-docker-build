FROM php:7.1

# Intsall some extra things we need
# at the OS Level
RUN apt-get update && apt-get install -y \
    openssh-client \
    rsync \
    git \
    zip \
    unzip \
    dnsutils \
    pngquant \
    dh-autoreconf \
    libpng-dev \
    libzip-dev

# Install NPM and some required global tools
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs \
    build-essential
RUN npm install -g marked \
    react-tools \
    node-gyp \
    node-sass \
    gulp \
    webpack@3.*

# Install Yarn and some of its tooling.
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Composer for php dep mgt.
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot \
    && rm -f /tmp/composer-setup.*

RUN pecl install zip
#RUN docker-php-ext-install ext-zip
RUN docker-php-ext-enable zip
RUN docker-php-ext-install pdo_mysql
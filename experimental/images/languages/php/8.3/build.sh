#!/usr/bin/env bash
set -euo pipefail

# Install PHP 8.3 from Sury repository
# Note: wget, curl, and ca-certificates are already installed in images/debian-12.6 via install-base-pkg-deb.sh
apt-get update && \
    apt-get install -y apt-transport-https lsb-release && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get install -y php8.3 php8.3-cli php8.3-common php8.3-xml php-pear php8.3-mbstring php-pgsql php-mysql php-mongo php-redis && \
    update-alternatives --install /usr/bin/php php /usr/bin/php8.3 100 && \
    update-alternatives --set php /usr/bin/php8.3 && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


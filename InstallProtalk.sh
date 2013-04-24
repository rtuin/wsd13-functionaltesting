#/bin/bash

repository="git://github.com/protalk/protalk.git"

localFolder="/vagrant/public/"

#this box has 5.3.2, upgrade for protalk
sudo add-apt-repository ppa:ondrej/php5
sudo echo "deb http://ppa.launchpad.net/ondrej/php5/ubuntu lucid main" >> /etc/apt/sources.list
sudo echo "deb-src http://ppa.launchpad.net/ondrej/php5/ubuntu lucid main" >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C
sudo apt-get upgrade -y --force-yes -qq
sudo apt-get install php5 -y --force-yes -qq

rm -rf "$localFolder"
git clone "$repository" "$localFolder"
mv "$localFolder/www" "$localFolder/local.dev"
cd "$localFolder"
curl -sS https://getcomposer.org/installer | php
php composer.phar install --dev

cp -a app/config/parameters.yml-dist app/config/parameters.yml
 mysql -u root --password=vagrant < "$localFolder/../protalk_setup.sql"
 app/console doctrine:schema:create
 app/console fos:user:create admin admin@example.com password --super-admin
 mysql -u root --password=vagrant < "$localFolder/app/console"
if (( $EUID != 0 )); then
    echo "Please enter the root directory"
    exit
fi
repairPanel(){
    cd /var/www/pterodactyl
    php artisan down
    rm -r /var/www/pterodactyl/resources
    curl -L https://github.com/HarunEpep/Backupan-Pterodactyl/blob/main/pterodactyl.tar.gz | tar -xzv
    chmod -R 755 storage/* bootstrap/cache
    composer install --no-dev --optimize-autoloader
    php artisan view:clear
    php artisan config:clear
    php artisan migrate --seed --force
    chown -R www-data:www-data /var/www/pterodactyl/*
    php artisan queue:restart
    php artisan up
}
while true; do
    read -p "Are you sure you want to uninstall the theme? [y/n] " yn
    case $yn in
        [Yy]* ) repairPanel; break;;
        [Nn]* ) exit;;
        * ) echo "Please select (y/yes) (n/no).";;
    esac
done
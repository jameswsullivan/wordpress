#!/bin/bash

chown -R www-data:www-data ${DOCUMENT_ROOT} ${SITE_CONFIG_DIR}

service apache2 start

cd ${SITE_CONFIG_DIR}
a2ensite *

a2enmod proxy
a2enmod proxy_http
a2enmod rewrite
a2enmod headers
a2enmod ssl
a2enmod http2
a2enmod status
a2enmod remoteip
#a2dismod mpm_prefork
#a2enmod mpm_event

service apache2 restart
service apache2 reload

exec "$@"
tail -f /dev/null


FROM php:7.3-stretch

# Set timezone to America/New_York
ENV TZ=America/New_York
ENV php_vars /usr/local/etc/php/conf.d/docker-vars.ini

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && echo "date.timezone=\"$TZ\"" >> /usr/local/etc/php/conf.d/docker-vars.ini

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  gnupg \
  apt-transport-https \
  cron \
  gettext && \
  rm -r /var/lib/apt/lists/*

RUN ln -s /usr/local/bin/php /usr/bin/php
RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini && \ 
  echo "log_errors = On"  >> ${php_vars} && \
  echo "display_errors = On"  >> ${php_vars} && \
  echo "error_log = /dev/stderr" >> ${php_vars} && \
  echo "display_startup_errors = On" >> ${php_vars} 

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY . .
COPY src/jobs/crontab /etc/cron.d/jobs-cron
# COPY src/jobs/php.ini /usr/local/etc/php
RUN chmod 755 /etc/cron.d/jobs-cron
RUN crontab /etc/cron.d/jobs-cron
RUN chmod +x src/jobs/start.sh

RUN touch /usr/src/app/src/crunz

CMD ["src/jobs/start.sh"]
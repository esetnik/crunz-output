#!/bin/bash
set -e

envsubst < src/jobs/set_env.sh > /set_env.sh
chmod +x /set_env.sh

echo 'starting cron job daemon...'

cron -f
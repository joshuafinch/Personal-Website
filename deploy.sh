#!/bin/bash
set -e

echo "Rsync files from the public directory"
# Rsync files from the public directory
rsync -rv --exclude '/.htaccess' --exclude '/.well-known/' --exclude=.DS_Store --delete-after $TRAVIS_BUILD_DIR/public/ $DEPLOYUSER@$DEPLOYHOST:$DEPLOYDIR

echo "Purge the cloudflare cache"
# Purge the cloudflare cache
curl -X DELETE "https://api.cloudflare.com/client/v4/zones/${CLOUDFLAREZONEID}/purge_cache" -H "X-Auth-Email: ${CLOUDFLAREAUTHEMAIL}" -H "X-Auth-Key: ${CLOUDFLAREAUTHKEY}" -H "Content-Type: application/json" --data '{"purge_everything":true}'

echo "Finished deploy.sh"

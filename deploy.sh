#!/bin/bash
set -e

echo "Starting rsync"
rsync -r --exclude '/.htaccess' --exclude '/.well-known/' --delete-after --quiet $TRAVIS_BUILD_DIR/public $DEPLOYUSER@$DEPLOYHOST:$DEPLOYDIR
echo "Finished rsync"

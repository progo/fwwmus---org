#!/bin/bash
# Small script to rebuild blog and upload it.
# Meant for org to call after its part of the process.
#
# Use first position argument `--noup' to skip all uploading to the
# servers.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEMPDIR='/home/progo/temp/blog_out/'
CODEDIR='/home/progo/koodi/blogen/'
ORG_DIR='/home/progo/dokumentit/blog/'
MIRROR='/home/progo/dokumentit/fwwm.us/'

#SERVER_PATH='/www/'
#CONFIG='/home/progo/dokumentit/blog/fwwm.clj'
#BLOGDIR='/home/progo/dokumentit/blog/out/'

##### LEIN
cd "$CODEDIR"
lein run &

if [ "--noup" = "$1" ] ;
then
    echo "Only running the local updates!"
    wait
    exit 0
fi

    # while lein does its job, push changes of blogen.
    git push origin master

    # and the blog as well
    cd "$ORG_DIR"
    git push origin main

wait

# Fix dvipng formulas for dark backgrounds by negating their colours
# from black to white.
cd "$TEMPDIR"
find -wholename '*ltxpng/*.png' -exec "$SCRIPTDIR/__publish_negate.sh" {} \;

#### The kapsi version right here
rsync -a . "$MIRROR"

cd "$MIRROR"
rsync -av . mipu@lakka.kapsi.fi:sites/fwwm.us/www/.

exit 0

#### The github pages version found below.

# Finally, make a commit and push
cd "$MIRROR"
git checkout gh-pages

cd "$TEMPDIR"
rsync -a . "$MIRROR"

## FYI: this is going to be problematic if something sensitive lies in
## the wrong directory...

cd "$MIRROR"
git ls-files --deleted -z | xargs -0 git rm >/dev/null 2>&1
git add -A
COM_MSG=`date +"Automated publish commit %F-%H%M%S"`
git commit -m "$COM_MSG"   > /dev/null 2>&1
git push origin gh-pages

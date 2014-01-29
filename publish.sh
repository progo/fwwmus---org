#!/bin/bash
# Small script to rebuild blog and upload it.
# Meant for org to call after its part of the process.

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEMPDIR='/home/progo/temp/blog/'
CODEDIR='/home/progo/koodi/blogen/'
GITREPO='/home/progo/dokumentit/fwwm.us/'

#SERVER_PATH='/www/'
#CONFIG='/home/progo/dokumentit/blog/fwwm.clj'
#BLOGDIR='/home/progo/dokumentit/blog/out/'

# Don't have to build uberjars for this. Although, could speed up.
cd "$CODEDIR"
lein run

# Fix dvipng formulas for dark backgrounds by negating their colours
# from black to white.
cd "$TEMPDIR"
find -wholename '*ltxpng/*.png' -exec "$SCRIPTDIR/__publish_negate.sh" {} \;

# Finally, make a commit and push
cd "$GITREPO"
git checkout gh-pages

cd "$TEMPDIR"
rsync -a . "$GITREPO"

## FYI: this is going to be problematic if something sensitive lies in
## the wrong directory...

cd "$GITREPO"
git ls-files --deleted -z | xargs -0 git rm >/dev/null 2>&1
git add -A
COM_MSG=`date +"Automated publish commit %F-%H%M%S"`
git commit -m "$COM_MSG"   > /dev/null 2>&1
git push origin gh-pages

#!/bin/bash
# Small script to rebuild blog and upload it.
# Meant for org to call after its part of the process.

echo This is not for use anymore
exit 1 

TEMPDIR='/home/progo/temp/omablog/'
CONFIG='/home/progo/dokumentit/blog/fwwm.clj'
CODE='/home/progo/koodi/static_blog/'
SERVER_PATH='/www/'
#BLOGDIR='/home/progo/dokumentit/blog/out/'

#Action! We presume that org has done its job and the blog.html in
# blog dir is regenerated.

# don't have to build uberjars for this.
cd "$CODE"
lein run -c "$CONFIG"

cd "$TEMPDIR"

# Fix dvipng formulas by negating their colours
for p in upload/blog_*png
do
    # We'll check if the main colour of the pic is white.
    # http://www.imagemagick.org/discourse-server/viewtopic.php?f=1&t=16936
    echo "Running $p..."
    

    if convert $p -colors 4 -geometry x5 histogram:- |\
          identify -format %c - |\
          sort -nr|\
          head -n1|\
          grep -q '255,255,255,'
    then
        echo "already white"
    else
        convert $p +negate $p
    fi
done

rsync -arv . progo@viuhka.fi:firewalkswith.me"$SERVER_PATH"

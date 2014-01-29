#!/bin/bash
# Aux for publish.sh
# Negates the colours if need be.

# We'll check if the main colour of the pic is white.
# http://www.imagemagick.org/discourse-server/viewtopic.php?f=1&t=16936

echo "Converting $1..."
if convert "$1" -colors 4 -geometry x5 histogram:- |\
      identify -format %c - |\
      sort -nr|\
      head -n1|\
      grep -q '255,255,255,'
then
    echo "already white"
else
    convert "$1" +negate "$1"
fi

#!/bin/bash
# collect tags from posts in the common pool for quick completions in
# the future postings.

settings="post-setup.org"

sed -i -e '/^#+TAGS:/d' $settings
echo "#+TAGS:" $(for post in **/*.org ;\
    do grep -E '^\*.*.+:$' $post \
    | grep -E ':[_a-z:]+:$' -o \
    | tr : ' ' | tr \  '\n' ; \
    done \
    | sort -u | tr '\n' ' ') >> $settings

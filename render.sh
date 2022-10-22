#!/bin/bash 

set -euo pipefail

PATH="$(pwd)/pandoc-2.19.2/bin:$PATH"

mkdir -p publish/out
mkdir -p temp

echo "<ul>" > all.html

echo "replacing.."
for f in ./guide/*.md
do
    d="$(dirname $f)"
    b="$(basename $f)"
    a="$(basename -s '.md' $f)"
    title="$(echo "$a" | sed 's:-: :g' | sed -E 's:^[0-9]+::g')"
    echo "$b"
    cat "$f" \
        | sed -E 's|https://bonsai:8535|./out|' \
        | sed -E 's|`ocaml skip|`|' \
        | sed -E 's|# [0-9]+.*||' \
        | sed -E 's/\(([^"]*).md\)/(\1.html)/g' \
        > "./temp/$b"

    printf '<li><a href="./%s.html"> %s </a></li>\n' "$a" "$title" >> "all.html"

done

echo "</ul>" >> all.html

echo "rendering"
for f in ./temp/*.md
do
    b="$(basename -s '.md' $f)"
    title="$(echo "$b" | sed 's:-: :g' | sed -E 's:^[0-9]+::g')"
    echo "$b"
    #sed 's|https://bonsai:8535|https://bonsai.red/out|' -i temp/*.md
    pandoc "$f" \
        --highlight-style=nord.theme \
        --template=template.html \
        --toc \
        --metadata title="$title" \
        -o "./publish/$b.html"
    echo "$f $b"
done

mv all.html ./publish/index.html

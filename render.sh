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
    pandoc "$f" \
        --highlight-style=nord.theme \
        --template=template.html \
        --toc \
        --metadata title="$title" \
        -o "./publish/$b.html"
    echo "$f $b"
done

echo '<link rel="stylesheet" type="text/css" href="/style.css" />' >> all.html

cat - all.html > ./temp/index.html <<EOF
    <div class="doc-title">
        <span id="bonsai">bonsai</span> 
    </div>
    <div class="toc_and_chapters">
EOF


cat ./temp/index.html - > ./publish/index.html <<EOF
    </div>
<p>
Bonsai is an OCaml library for building and running pure, incremental,
state-machines. It is primarily used as a foundational library for web
applications, where immutable (virutal) representations of view are composed
together with basic primitives.  
</p>

<p>
Incrementality is used to reduce unnecessarily recomputing parts of the
application, and compared to other frameworks that have incrementality at the
view-computation level, Bonsai can incrementalize any subcomputation.  
</p>

<p>
The "component" abstraction provided by Bonsai enables not only incrementalization 
of inputs and outputs, but also a powerful encapsulation of component-local state.
Component-local state is private by default, but because components produce values 
of arbitrary types (not just views!), exposing component state to other components 
is trivial.
</p>

<p>
This website contains the Bonsai Guide, but make sure to 
<a href="https://github.com/janestreet/bonsai">check out the project on github too!</a>
</p>

<style>
p:nth-of-type(1) {
  margin-top:0;
}
</style>
EOF
cp style.css ./publish/style.css

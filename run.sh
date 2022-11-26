#!/bin/bash 

set -euo pipefail

if [ ! -d _opam ]; then 
  opam switch create ./ ocaml-base-compiler.4.12.1
  eval $(opam env) 
  opam repo add "janestreet-bleeding" "https://github.com/janestreet/opam-repository.git#e0f594b09711e5daf55ce097bb8d653e7ec87ea2"
  eval $(opam env) 
  opam update
  opam install -y dune bonsai 
else 
  echo "skipping opam switch and install"
  opam install ppx_css
fi

eval $(opam env) 

if [ ! -d bonsai_guide_code ]; then 
  git clone https://github.com/janestreet/bonsai.git
  mv bonsai/examples/bonsai_guide_code ./
  mv bonsai/dune-project ./

  sed -i -E 's/bonsai_/bonsai\./g' ./bonsai_guide_code/dune 
  sed -i -E 's/ppx_bonsai/bonsai.ppx_bonsai/g' ./bonsai_guide_code/dune 

  rm -rf bonsai
else 
  echo "skipping download of bonsai"
fi

mkdir -p publish/out
dune build --release ./bonsai_guide_code/main.bc.js

cp _build/default/bonsai_guide_code/main.bc.js ./publish/out/main.bc.js

cp ./bonsai_guide_code/index.html ./publish/out/index.html
echo "<style>" >> ./publish/out/index.html
cat example.css >> ./publish/out/index.html
echo "</style>" >> ./publish/out/index.html

cp ./bonsai_guide_code/style.css ./publish/out/style.css
cp index.html ./publish/index.html

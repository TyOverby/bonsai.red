#!/bin/bash 

if [ ! -d _opam ]; then 
  opam switch create ./ ocaml-base-compiler.4.12.1
  eval $(opam env) 
  opam repo add "janestreet-bleeding" "https://github.com/janestreet/opam-repository.git#e0f594b09711e5daf55ce097bb8d653e7ec87ea2"
  eval $(opam env) 
  opam update
  opam install dune bonsai
fi

if [ ! -d bonsai_guide_code ]; then 
  git clone https://github.com/janestreet/bonsai.git
  mv bonsai/examples/bonsai_guide_code ./
  mv bonsai/dune-project ./

  sed -i -E 's/bonsai_/bonsai\./g' ./bonsai_guide_code/dune 
  sed -i -E 's/ppx_bonsai/bonsai.ppx_bonsai/g' ./bonsai_guide_code/dune 

  rm -rf bonsai
fi


mkdir -p out 
dune build ./bonsai_guide_code/main.bc.js
cp _build/default/bonsai_guide_code/main.bc.js ./out/main.bc.js
cp ./bonsai_guide_code/index.html ./out/index.html
cp ./bonsai_guide_code/style.css ./out/style.css

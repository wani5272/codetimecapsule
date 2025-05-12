#!/bin/bash 
sphinx-build -a -b latex -d _build/doctrees . _build/xetex && pushd _build/xetex; latexmk -xelatex -pdf cbook.tex && popd
cp _build/xetex/cbook.pdf docs

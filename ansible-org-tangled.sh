#!/bin/sh
# -*- mode: shell-script -*-
#
# tangle files with org-mode
# see: http://orgmode.org/manual/Batch-execution.html
#
DIR=`pwd`
FILE=""

for i in $@; do
    FILE="\"$i\""
    emacs -Q --batch \
	--eval "(progn
     (add-to-list 'load-path (expand-file-name \"~/src/org/lisp/\"))
     (add-to-list 'load-path (expand-file-name \"~/src/org/contrib/lisp/\" t))
     (require 'org)(require 'org-exp)(require 'ob)(require 'ob-tangle)
     (setq org-src-preserve-indentation t)
     (mapc (lambda (file)
            (find-file (expand-file-name file \"$DIR\"))
            (org-babel-tangle)
            (kill-buffer)) '($FILE)))" 2>&1 |grep tangled


    # execute ansible command to yml file
    string_filename=${i##*/}
    string_filename_without_extension=${string_filename%.*}
    string_path=${i%/*}
    ansible-playbook ${string_path}/${string_filename_without_extension}.yaml
done

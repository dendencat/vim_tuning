set nocompatible

if filereadable(expand('~/.vim/vimrc_core.vim'))
  execute 'source' fnamescape('~/.vim/vimrc_core.vim')
endif

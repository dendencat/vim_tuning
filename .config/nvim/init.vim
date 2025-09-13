" Neovimeでも~/.vim以下のファイルをそのまま使えるようにパスを調整
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Vimのコア設定を流用
if filereadable(expand('~/.vim/vimrc_core.vim'))
  execute 'source' fnamescape('~/.vim/vimrc_core.vim')
endif

if has('nvim')
  set termguicolors
  " Lua migration point
  if isdirectory(stdpath('config') . '/lua')
    "ex. lua require('myinit')
  endif
endif
" プラグイン管理の開始
call plug#begin('~/.local/share/nvim/plugged')

" プラグイン一覧
Plug 'junegunn/fzf'
Plug 'scrooloose/nerdtree'

" プラグイン管理の終了
call plug#end()

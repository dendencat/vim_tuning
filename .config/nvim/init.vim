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

  function! s:on_lsp_buffer_enabled() abort
    if &buftype ==# 'nofile' || &filetype =~# '^\(quickrun\)' || getcmdwintype() ==# ':'
      return
    endif
    " Language Serverが有効になったバッファに対する設定
    setlocal omnifunc=lsp#complete
    " 以下は好みで設定
    " nmap <buffer> gd <plug>(lsp-definition)
    " nmap <buffer> <f2> <plug>(lsp-rename)
    " nmap <buffer> c-k <plug>(lsp-hover)
  endfunction

  augroup vimrc_lsp_install
    autocmd!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END
endif
" プラグイン管理の開始
call plug#begin('~/.local/share/nvim/plugged')

" プラグイン一覧
Plug 'junegunn/fzf'
Plug 'scrooloose/nerdtree'
Plug 'prabirshrestha/vim-slp'
Plug 'mattn/vim-lsp-settings'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" プラグイン管理の終了
call plug#end()

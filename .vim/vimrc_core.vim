" === Common: 共通処理 ===

if !has('neovim') | set nocompatible | endif
syntax on
filetype plugin indent on
set number
set hidden
set ignorecase smartcase
set mouse=a
set updatetime=300

" === Neovim互換 ===
if has('nvim')
  set clipboard=unamedplus
endif

" === vimplug ===
call plug#begin('~/.vim/plugged')

" 共通
  Plug 'tpope/vim-surround'
  " Plug 'tpope/vim-commentary'

" 起動を遅らせる
Plug 'junegunn/fzf', { 'do': {-> fzf#install()}, 'on': 'FZF' }
Plug 'junegunn/fzf.vim', { 'on': ['FZF', 'Files', 'Buffers'] }

" nnoremap <Leader>fを使うため、混乱を避けるため、Leaderを宣言する
let mapleader = ' '
nnoremap <silent> <Leader>f :Files<CR>

" neovim専用(ガード+遅延方針)
if has('nvim')
  Plug 'neovim/nvim-lspconfig', { 'on': [] } " 自動起動しない
  " 実際は必要時に :LspStart を叩く or ファイルタイプで遅延起動
  augroup LspOnDemand
    autocmd!
    autocmd FileType python,lua,rust lua << EOF
      local lspconfig = require('lspconfig')
      if not lspconfig.pyright.__lsp_started then lspconfig.pyright.setup({}) end
  EOF
    augroup END
endif

call plug#end()

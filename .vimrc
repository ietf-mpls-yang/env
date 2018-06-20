if has("unix")
  set shell=bash
endif

" Vundle
set rtp+=~/.vim.tsaad/Vundle.vim
call vundle#begin('~/.vim.tsaad')
Plugin 'VundleVim/Vundle.vim'
Plugin 'nathanalderson/yang.vim'
Plugin 'vim-scripts/cecscope'
Plugin 'mrtazz/DoxygenToolkit.vim'
Plugin 'vim-scripts/c.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'erig0/cscope_dynamic'
Plugin 'chazy/cscope_maps'
Plugin 'MarkdownFootnotes'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ervandew/supertab'
Plugin 'godlygeek/tabular'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'rbgrouleff/bclose.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'mhartington/tmuxline.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'itchyny/lightline.vim'
" Plugin 'vim-scripts/SearchComplete'
" Plugin 'benmills/vimux'
" Plugin 'vim-scripts/Command-T'
" Plugin 'Valloric/YouCompleteMe'
" Plugin 'tpope/vim-fugitive'
" Plugin 'tpope/vim-commentary'
call vundle#end()

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" Put your non-Plugin stuff after this line

" Tip #796 - Search only over a visual range {{{
vnoremap / <Esc>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
vnoremap ? <Esc>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
" }}}

" Searching {{{
set incsearch
set hlsearch
set iskeyword=@,48-57,_,192-255
" }}}

" Syntax highlighting {{{
syntax on
syntax sync fromstart
filetype plugin indent on
" }}}

" Force file type detection when file name is changed {{{
autocmd BufFilePost * filetype detect
" }}}

" Disable some stuff on large files {{{
let g:LargeFile = 10 * 1024 * 1024
if has("autocmd")
  augroup LargeFile
    au BufReadPre * call JsoftCheckLargeFile(expand("<afile>"))
    function! JsoftCheckLargeFile(f)
      if g:LargeFile && getfsize(a:f) >= g:LargeFile
	let b:LargeFileEventIgnoreKeep=&eventignore
	let b:LargeFileUndoLevelsKeep=&undolevels
	set eventignore+=FileType
	setlocal noswapfile
	setlocal bufhidden=unload
	setlocal foldmethod=manual nofoldenable
	setlocal nomodeline
	let f=escape(substitute(a:f,'\','/','g'),' ')
	execute "au LargeFile BufEnter ".f." set undolevels=-1"
	execute "au LargeFile BufLeave ".f." let &undolevels=".b:LargeFileUndoLevelsKeep."|set eventignore=".b:LargeFileEventIgnoreKeep
	execute "au LargeFile BufUnload ".f." au! LargeFile * ".f
	echomsg "Handling a large file... undo, swapfile and FileType events disabled"
      endif
    endfunction
  augroup END
endif
" }}}

" Toggle 'paste' mode using \p {{{
map <leader>y :set paste! paste? <cr>
" }}}

set backspace=indent,eol,start
set wildmode=list:longest

let g:solarized_termcolors=256

set grepprg=grep\ -n
set timeoutlen=500
if &diff
  colorscheme darkblue
  " colorscheme evening
else
  colorscheme darkblue
  " colorscheme kruby
endif

highlight Visual cterm=bold ctermbg=Blue ctermfg=NONE

" Make things quicker... I'm not using spelling on servers at Cisco
let g:loaded_vimspell = 0
fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map f :call ShowFuncName() <CR>
vmap <Leader>tt :Tabularize /\S\+;<CR>


" Map keys for tab next/prev and new/close
nnoremap <Leader><Leader>n :tabnext<CR>
nnoremap <Leader><Leader>b :tabprevious<CR>
nnoremap <Leader><Leader>d :tabclose<CR>
nnoremap <Leader><Leader>t :tabnew<CR>

"Map keys for buffer next/prev and new/close
nnoremap <Leader>n :bn<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>d :bd<CR>

"cscope_dynamic stuff
nmap <F12> <Plug>CscopeDBInit

set hidden
set autoindent
set gfn=Monospace\ 10   " use this font
set lazyredraw
behave xterm
set selectmode=mouse
" set clipboard=exclude:.*
" Send more characters for redraws
set ttyfast
set clipboard=autoselect,exclude:.* 

" Enable mouse use in all modes
set mouse=a
set cursorcolumn
" set termguicolors
set cursorline

" Indentation {{{
set tabstop=8
set shiftwidth=4
set smarttab
set autoindent
set expandtab
command! -nargs=0 ToggleSoftTabStop :call <SID>ToggleSoftTabStop()
function! s:ToggleSoftTabStop()
  if !exists('b:ToggleSoftTabStop_save_softtabstop')
    let b:ToggleSoftTabStop_save_softtabstop = 0
  endif
  let t = b:ToggleSoftTabStop_save_softtabstop
  let b:ToggleSoftTabStop_save_softtabstop = &softtabstop
  let &softtabstop = t
  set softtabstop?
endfunction 
" map <Leader>t :ToggleSoftTabStop<CR>

" }}}

let g:ctrlp_clear_cache_on_exit = 0

let g:DoxygenToolkit_briefTag_pre="@brief: "
let g:DoxygenToolkit_paramTag_pre="@param[in|out]  "
let g:DoxygenToolkit_paramTag_post=" - "
let g:DoxygenToolkit_returnTag=   "@return "
let g:DoxygenToolkit_authorName="Tarek Saad"
let g:DoxygenToolkit_licenseTag="My own license"

let g:airline#extensions#tabline#enabled = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:tmuxline_powerline_separators = 1
let g:airline_powerline_fonts = 1
set ambiwidth=double
set laststatus=2

" Override search match color to what we want
highlight Search guibg='brown' guifg='NONE'

" Disable Background Color Erase (BCE) so that color schemes
" work properly when Vim is used inside tmux and GNU screen.
set t_ut=

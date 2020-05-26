" -----------------------------------------------------------------------------
" Plugins
" -----------------------------------------------------------------------------

call plug#begin("~/.vim/plugged")

  " Theme
  Plug 'morhetz/gruvbox'
  "Plug 'ayu-theme/ayu-vim'
  "Plug 'joshdick/onedark.vim'
  "Plug 'flrnd/plastic.vim'
  "Plug 'dracula/vim', { 'as': 'dracula' }
  
  " Language Client
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver']

  " TypeScript Highlighting
  Plug 'mattn/emmet-vim'
  Plug 'rstacruz/vim-closer'

  "go vim
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

  Plug 'tpope/vim-surround'

  " File Explorer with Icons
  Plug 'scrooloose/nerdtree'
  Plug 'ryanoasis/vim-devicons'

  Plug 'terryma/vim-multiple-cursors' 

  "Airline status bar
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
" post install (yarn install | npm install) then load plugin only for editing supported files
  Plug 'prettier/vim-prettier', {
   \ 'do': 'npm install',
   \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
  
  " File Search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  Plug 'jiangmiao/auto-pairs'
  Plug 'sheerun/vim-polyglot'
  Plug 'pangloss/vim-javascript'

  " Showing vertical indent lines
  Plug 'Yggdroot/indentLine'
  Plug 'preservim/nerdcommenter'

  " Dim paragraphs above and below the active paragraph.
  Plug 'junegunn/limelight.vim'
  " Distraction free writing by removing UI elements and centering everything.
  Plug 'junegunn/goyo.vim'
call plug#end()


" -----------------------------------------------------------------------------
" Color settings
" -----------------------------------------------------------------------------

" Theme
if &term =~# '^screen'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

colorscheme gruvbox
set termguicolors cursorline
filetype plugin on "for nerdcomment plug
filetype indent on
syntax on


" -----------------------------------------------------------------------------
" Status line
" -----------------------------------------------------------------------------

" Heavily inspired by: https://github.com/junegunn/dotfiles/blob/master/vimrc
function! s:statusline_expr()
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'

  return '[%n] %f %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction


let &statusline = s:statusline_expr()

" -----------------------------------------------------------------------------
" Basic Settings
"   Research any of these by running :help <setting>
" -----------------------------------------------------------------------------

set clipboard+=unnamedplus " clipboard support
set splitright
set splitbelow
set relativenumber 
set number
" Tab size settings
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent
set backspace=indent,eol,start confirm
set visualbell
set laststatus=2
set wrap


" Automaticaly sets the tab size if the file is html/css.
autocmd Filetype css setlocal tabstop=2
autocmd Filetype html setlocal tabstop=2
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif


" -----------------------------------------------------------------------------
" Basic mappings
" -----------------------------------------------------------------------------

let mapleader=" "
let maplocalleader=" "

nnoremap <silent> <C-b> :NERDTreeToggle<CR>
" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>
"Prettier
nmap <Leader>py <Plug>(Prettier)
"Emmet auto complete with tab.
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

"Change panel size with arrow keys
nnoremap <Up> :resize +2<CR> 
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>

nnoremap <C-t> : call Toggle_transparent()<CR>

nnoremap <CR> 
nmap <S-Enter> O<Esc>j
nmap <CR> o<Esc>k
noremap <Leader>s :w<CR>

" Press * to search for the term under the cursor or a visual selection and
" then press a key below to replace all instances of it in the current file.
nnoremap <Leader>r :%s///g<Left><Left>
nnoremap <Leader>rc :%s///gc<Left><Left><Left>

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors).
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> s* "sy:let @/=@s<CR>cgn

" Hardcore mode, disable arrow keys.
"noremap <Up> <NOP>
"noremap <Down> <NOP>
"noremap <Left> <NOP>
"noremap <Right> <NOP>


" -----------------------------------------------------------------------------
" Plugin settings, mappings 
" -----------------------------------------------------------------------------
"
" .............................................................................
" scrooloose/nerdtree
" .............................................................................
"
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''

" .............................................................................
" junegunn/fzf.vim
" .............................................................................
"
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'
nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

" requires silversearcher-ag
" used to ignore gitignore files
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" Map a few common things to do with FZF.
nnoremap <silent> <Leader><Enter> :Buffers<CR>
nnoremap <silent> <Leader>l :Lines<CR>

" Allow passing optional flags into the Rg command.
"   Example: :Rg myterm -g '*.md'
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " . <q-args>, 1, <bang>0)


let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#config#tab_width = '2'

"emmet leader key
let g:user_emmet_leader_key = '<C-s>'

"Airline
let g:airline_theme = 'gruvbox'
let g:airline_powerline_fonts = 1


" ----------------------------------------------------------------------------
" Basic commands
" ----------------------------------------------------------------------------

" open terminal on ctrl+;
" uses zsh instead of bash
function! OpenTerminal()
  split term://bash
  resize 10
endfunction
nnoremap <c-n> :call OpenTerminal()<CR>

" Transparent background
let t:is_transparent = 0
function! Toggle_transparent()
    if t:is_transparent == 0
        hi Normal guibg=NONE ctermbg=NONE
        let t:is_transparent = 1
    else
        set background=dark
        let t:is_tranparent = 0
    endif
endfunction


autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
  " ...
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

set nocompatible 	" Use Vim settings, rather than Vi settings
set softtabstop=2 	" tab == 2 spaces
set shiftwidth=2  	" indent by 4 spaces when autoindenting
set tabstop=4		" Show existing tab with 4 space width
syntax on		" Enable syntax highlighting
filetype indent on	" Enabled indenting for files
set autoindent		" Enable auto indenting
set number		" Enable line numbers
colorscheme desert	
set nobackup		" Disable backup files
set laststatus=2	" show status line
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\
set wildmenu 		" Display command line's tab complete options as a menu.
set bs=2			" Let backspace work in insert mode
set clipboard=unnamed
set hlsearch		" Highlight search results"
set hidden			" Just hide buffers when switching"
set cmdheight=2		" Give more space for displaying messages
set shortmess+=c	" Don't pass messages to |ins-completion-menu|
set signcolumn=auto	" Only show signcolumn on errors

" Auto install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| end

call plug#begin()

" Make sure you use single quotes
Plug 'christoomey/vim-tmux-navigator'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'elzr/vim-json'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-endwise'
Plug 'jiangmiao/auto-pairs'
Plug 'xavierchow/vim-swagger-preview'
Plug 'dense-analysis/ale'
Plug 'mileszs/ack.vim'
Plug 'fatih/vim-go'
Plug 'neoclide/coc.nvim'
Plug 'honza/vim-snippets'
Plug 'axelf4/vim-strip-trailing-whitespace'
Plug 'vim-airline/vim-airline'
Plug 'ojroques/vim-scrollstatus'
Plug 'jpalardy/vim-slime'

call plug#end()

" vim-scrollstatus
let g:airline_section_x = '%{ScrollStatus()} '
let g:airline_section_y = airline#section#create_right(['filetype'])
let g:airline_section_z = airline#section#create([
            \ '%#__accent_bold#%3l%#__restore__#/%L', ' ',
            \ '%#__accent_bold#%3v%#__restore__#/%3{virtcol("$") - 1}',
            \ ])

silent! nmap <silent> <Leader>p :NERDTreeToggle<CR>
nnoremap <silent> <C-f> :call FindInNERDTree()<CR>

" Turn off concealing (of quotes, etc.)
let g:vim_json_syntax_conceal = 0

" Use ack with Ag (this requires ack to be install)
let g:ackprg = 'ag --nogroup --nocolor --column'

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: User command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" This breaks for me...
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              "\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" GoTo code navigation.

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.

autocmd ColorScheme * highlight CocErrorFloat guifg=#ffffff
autocmd ColorScheme * highlight CocInfoFloat guifg=#ffffff
autocmd ColorScheme * highlight CocWarningFloat guifg=#ffffff
autocmd ColorScheme * highlight SignColumn guibg=#adadad

let g:coc_global_extensions = ['coc-solargraph']

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"}

" Put swap files in ~/.vim/swap
set directory=$HOME/.vim/swp//

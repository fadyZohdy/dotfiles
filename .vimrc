set nocompatible              " be iMproved, required
filetype plugin on
filetype indent on
filetype plugin indent on    " required
syntax on
set backspace=indent,eol,start
set mouse=a  " point and select with mouse click
let g:indentLine_char = '.'
set encoding=utf-8
set relativenumber
set nowrap
set virtualedit=block " make selection better not bounded to end of lines
set conceallevel=0

set termguicolors
let g:gruvbox_italic=1
colorscheme gruvbox
let g:airline_theme='gruvbox'
let g:gruvbox_contrast_dark='hard'

highlight Cursor guifg=white guibg=black
highlight iCursor guifg=green guibg=steelblue
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver100-block-Cursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkwait10

nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> :tabprevious<CR>
nnoremap <Right> :tabnext<CR>

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" ------------------- search -----------------------
set hlsearch  " highlight the searched word
set incsearch " jump automatically to the first occurence of the search
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR> " Press Space to turn off highlighting and clear any message already displayed.
nnoremap f/ :FuzzySearch<CR>
let g:fuzzysearch_prompt = '/'
let g:fuzzysearch_ignorecase = 1

"function HighlightNearCursor()
"  if !exists("s:highlightcursor")
"    match Todo /\k*\%#\k*/
"    let s:highlightcursor=1
"  else
"    match None
"    unlet s:highlightcursor
"  endif
"endfunction

" Copy matches of the last search to a register (default is the clipboard).
" Accepts a range (default is whole file).
" 'CopyMatches'   copy matches to clipboard (each match has \n added).
" 'CopyMatches x' copy matches to register x (clears register first).
" 'CopyMatches X' append matches to register x.
" We skip empty hits to ensure patterns using '\ze' don't loop forever.
command! -range=% -register CopyMatches call s:CopyMatches(<line1>, <line2>, '<reg>')
function! s:CopyMatches(line1, line2, reg)
  let hits = []
  for line in range(a:line1, a:line2)
    let txt = getline(line)
    let idx = match(txt, @/)
    while idx >= 0
      let end = matchend(txt, @/, idx)
      if end > idx
	call add(hits, strpart(txt, idx, end-idx))
      else
	let end += 1
      endif
      if @/[0] == '^'
        break  " to avoid false hits
      endif
      let idx = match(txt, @/, end)
    endwhile
  endfor
  if len(hits) > 0
    let reg = empty(a:reg) ? '+' : a:reg
    execute 'let @'.reg.' = join(hits, "\n") . "\n"'
  else
    echo 'No hits'
  endif
endfunction




" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'morhetz/gruvbox'
Plugin 'tpope/vim-fugitive'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'Yggdroot/indentLine'
Plugin 'andrewstuart/vim-kubernetes'
Plugin 'stephpy/vim-yaml'
Plugin 'moll/vim-node'
Plugin 'derekwyatt/vim-scala'
Plugin 'natebosch/vim-lsc'   " need to install metals-vim for this to work
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'pangloss/vim-javascript'
Plugin 'isRuslan/vim-es6'
Plugin 'octave.vim'
"Plugin 'w0rp/ale'
Plugin 'vim-airline/vim-airline'
"Plugin 'ludovicchabant/vim-gutentags'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'

Plugin 'neovimhaskell/haskell-vim'
Plugin 'nbouscal/vim-stylish-haskell'

Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'

Plugin 'junegunn/fzf.vim'
Plugin 'ggvgc/vim-fuzzysearch'
Plugin 'osyo-manga/vim-anzu'

Plugin 'wincent/ferret'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-unimpaired'
Plugin 'JamshedVesuna/vim-markdown-preview'

" All of your Plugins must be added before the following line
call vundle#end()            " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let vim_markdown_preview_github=1
let vim_markdown_preview_browser='Google Chrome'

let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': [] }

" -------------------- ctags -------------------------------
let g:easytags_async=1
let g:tags='~/.vimtags'
let g:easytags_auto_highlight = 0


"------------------- copy to clipboard -----------------------
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif
"-----------------------------------------------------------

" autocmd FileType haskell nnoremap <buffer> <leader>? :call ale#cursor#ShowCursorDetail()<cr>
autocmd Filetype haskell setlocal expandtab tabstop=8 softtabstop=4 shiftwidth=4 shiftround

" -------------------------- Ruby ------------------------
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_ruby_rubocop_args = "-R"
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType eruby setlocal expandtab shiftwidth=2 tabstop=2

" -------------------- nerdTree -------------------------------
:nnoremap <C-g> :NERDTree<CR>
let g:NERDTreeDirArrows=0
nmap ,n :NERDTreeFind<CR>

" ------------------------ fzf ------------------------------------
:nnoremap <C-p> :FZF<CR>
set rtp+=/usr/local/opt/fzf
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

" --------------------------- scala ------------------------------
" Configuration for vim-scala
au BufRead,BufNewFile *.sbt set filetype=scala

" Configuration for vim-lsc
let g:lsc_enable_autocomplete = v:false
let g:lsc_server_commands = {
  \ 'scala': 'metals-vim'
  \}
let g:lsc_auto_map = {
    \ 'GoToDefinition': 'gd',
    \}


augroup myvimrchooks
    au!
    autocmd bufwritepost .vimrc source ~/.vimrc
augroup END


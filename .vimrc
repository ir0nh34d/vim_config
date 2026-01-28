" Last Modified: 2026-01-27 08:25:36
scriptencoding utf-8

" Enable syntax highlighting
syntax enable
let mapleader='\'

function! Grep(pattern, location)
    exe "noautocmd vimgrep /" . a:pattern . "/gj " . a:location
    if (!empty(getqflist()))
        silent exe 'copen'
    endif
endfunction

" Update the Last Modified date for a file
function! UpdateLastModified()
    let last_change_anchor='\(" Last Modified:\s\+\)\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2}'
    let last_change_line=search('\%^\_.\{-}\(^\zs' . last_change_anchor . '\)', 'n')
    if last_change_line != 0
        let last_change_time=strftime('%Y-%m-%d %H:%M:%S', localtime())
        let last_change_text=substitute(getline(last_change_line), '^' . last_change_anchor, '\1', '') . last_change_time
        call setline(last_change_line, last_change_text)
    endif
endfunction

" << Settings >>
if exists ("+autochdir")
    set autochdir
endif
if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    set fileencodings=ucs-bom,utf-8,latin1
endif
"set tabline=%!MyTabLine()
set nocompatible
set list listchars=tab:¤\ ,trail:·,extends:»,precedes:«
set expandtab
set tabstop=2
set nobk
set nu
set title
set statusline=%F%m%r%h%w\ \(%{&ff}\)\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set laststatus=2
set shiftwidth=4
set cmdheight=1
set nowrap
set sidescroll=5
set so=5
set history=50
set ruler
set showcmd
set incsearch
set hlsearch
set backspace=indent,eol,start
set autoindent
set wildmenu wildmode=full
set textwidth=0
set foldmethod=syntax
set autoread
set background=dark
set cursorline
set showtabline=2
set switchbuf=useopen,usetab
set mouse=a
set signcolumn=number
set completeopt=menu,menuone,popup,noselect,noinsert,fuzzy
set completepopup=align:menu,border:off,highlight:Pmenu

if exists ("+spell")
    set spelllang=en_ca
    nnoremap <leader>s :set spell! spell?<CR>
    set spelloptions=camel
endif

if has('persistent_undo')
    set undofile " Enable persistent undo
    set undodir=~/.vim/undo/ " Store undofiles in a tmp dir
endif

" Override the default tab tile colors so that window count is readable
function! s:gruvbox_material_custom() abort
  " Initialize the color palette.
  " The first parameter is a valid value for `g:gruvbox_material_background`,
  " the second parameter is a valid value for `g:gruvbox_material_foreground`,
  " and the third parameter is a valid value for `g:gruvbox_material_colors_override`.
  let l:palette = gruvbox_material#get_palette('medium', 'material', {})
  " Define a highlight group.
  " The first parameter is the name of a highlight group,
  " the second parameter is the foreground color,
  " the third parameter is the background color,
  " the fourth parameter is for UI highlighting which is optional,
  " and the last parameter is for `guisp` which is also optional.
  " See `autoload/gruvbox_material.vim` for the format of `l:palette`.
  call gruvbox_material#highlight('Title', l:palette.none, l:palette.none, 'bold')
endfunction

"augroup GruvboxMaterialCustom
"  autocmd!
"  autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
"augroup END

"let g:gruvbox_material_background = 'medium'
"colo gruvbox-material
colo retrobox

" << Mappings >>
" Break undo cycle
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" Cycle through tabs
nnoremap <leader>] :tabn<CR>
nnoremap <leader>[ :tabp<CR>

" Cycle through buffers
nnoremap <tab> :bnext<CR>
nnoremap <S-tab> :bprevious<CR>

" Toggle search highlighting
nnoremap <leader>h :set invhlsearch<CR>

" Open files in tabs based on extension or name under cursor
nnoremap <leader>to <C-W>gf

" Open files based on extension or name under cursor
nnoremap <leader>o gf

" Get the syntax id for the item under the cursor
nnoremap <leader>y :echo synIDattr(synID(line("."), col("."), 1), "name")<CR>

" View as hex
nnoremap <leader>x :%!xxd<CR>

nnoremap <silent> <leader>g :call Grep(expand("<cword>"), "%:p")<CR>
vnoremap <Up> k
vnoremap <Down> j
vnoremap <Left> h
vnoremap <Right> l

" << Commands >>
com! -nargs=+ Grep :call Grep(<f-args>)

" << Autocommands >>
if has("autocmd")
    " enable filetype plugin and set indent
    filetype plugin indent on

    if exists ("+spell")
        " Don't spellcheck CamelCase words
        au Syntax * syn match CamelCase "\<\%(\u\l*\)\{2,}\>" transparent containedin=.*Comment.* contains=@NoSpell contained
        " Enable spell check by default for text and markdown files
        au FileType text,markdown setlocal spell
    endif

    " When editing a file, always jump to the last known cursor position.
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    " Open a quickfix window with grep
    au QuickFixCmdPost *grep* cwindow

    augroup vimrc
        au!

        " Update the Last Modified time for vim and cpp files
        au BufWritePre *vimrc,*.vim call UpdateLastModified()

        " Reload .vimrc/.gvimrc when it's been edited
        au BufWritePost .vimrc source ~/.vimrc
        au BufWritePost .gvimrc source ~/.gvimrc
    augroup END
endif

" Set the cursor to match the same behaviour as GVim from within iTerm2
if $TERM_PROGRAM =~ "iTerm.app"
    set termguicolors
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Set the cursor to match the same behaviour as GVim from within Mac Terminal
if $TERM_PROGRAM =~ "Apple_Terminal"
    set termguicolors
    let &t_SI.="\e[6 q"
    let &t_SR.="\e[4 q"
    let &t_EI.="\e[2 q"
endif

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL


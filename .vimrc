" Vundle bundle configs
let g:syntastic_coffee_lint_options = "-f ~/bDotfiles/coffeelint.json"
let g:syntastic_mode_map = {'active_filetypes': [], 'mode': 'passive', 'passive_filetypes': []}

let g:instant_markdown_slow = 1

" Vundle nonsense
set nocompatible
filetype off

if isdirectory($HOME."/.vim/bundle/vundle")
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

    " let Vundle manage Vundle
    " required!
    Bundle 'gmarik/vundle'
    Bundle 'tpope/vim-fugitive'
    Bundle 'tpope/vim-surround'
    Bundle 'tpope/vim-commentary'
    Bundle 'tpope/vim-unimpaired'
    Bundle 'tpope/vim-speeddating'
    Bundle 'scrooloose/syntastic'
    Bundle 'matchit.zip'
    Bundle 'kchmck/vim-coffee-script'
    Bundle 'altercation/vim-colors-solarized'
    Bundle 'a.vim'
    Bundle 'msanders/snipmate.vim'
    Bundle 'wincent/Command-T'
    " Bundle 'bsl/obviousmode'
    " Bundle 'http://www.drchip.org/astronaut/vim/vbafiles/hilinks.vba.gz'
    Bundle 'panozzaj/vim-autocorrect'
    Bundle 'dag/vim2hs'
    Bundle 'tpope/vim-markdown'
    Bundle 'suan/vim-instant-markdown'
    Bundle 'lukaszkorecki/workflowish'
    Bundle 'b4winckler/vim-angry'
else
    echomsg "Vundle not installed! Hecka weirdness may ensue."
endif

filetype plugin indent on
"syntax enable

set t_Co=256

if filereadable($HOME."/.vim/colors/lunatic.vim")
    colorscheme lunatic
else
    echomsg "Skipping colorscheme cause it's no-findings."
endif

set aw
set ai
set bg=dark
" set cpo+=J
set dict=/usr/share/dict/words
set et
set fdc=3
set fo+=l
set foldtext=BFoldtext()
set gp=ack-grep
set hidden
set modeline
set is
set laststatus=2 " Always show status
set list
set lcs=tab:-\ ,trail:⎵,extends:>,precedes:<
set mouse=
set showcmd
set sidescroll=1
set sidescrolloff=1
set smartcase ignorecase
set statusline=%f%m%r%h%w\%=[L:\%l\ C:\%c\ A:\%b\ H:\x%B\ P:\%p%%]
set sol!
set sw=4
set swb=usetab
set titlestring=vi:\ %t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
set ts=4
set tw=80
set wildmode=longest,list
set wiw=83 nowrap " For shoots and googles

let mapleader = ","
let g:sh_fold_enabled=1
let g:tex_flavor="latex"
let g:Tex_DefaultTargetFormat="pdf"

let g:haddock_browser = "/usr/bin/google-chrome"
let g:haddock_indexfiledir = "~/.vim"

map <Leader>e zfaB

nmap <Leader>S :so ~/.vimrc<cr>
nmap <Leader>V :e  ~/.vimrc<cr>

" Make <c-s> useful!
nmap <c-s> :up<cr>
vmap <c-s> :w 
imap <c-s> <esc>:up<cr>

" Escape key? No thanks
vmap <Tab> <Esc>
imap <Tab> <Esc>
omap <Tab> <Esc>
" Catches a standard fuck up I do:
nmap r<Tab> <Esc>

" Adds C-u to the undo stream:
inoremap <C-u> <esc>S

nmap <C-w>M <C-w>\|<C-w>_

" There is never a time I don't want this, I believe.
noremap j gj
noremap k gk
imap <up> <c-o>k
imap <down> <c-o>j
nmap <up> k
nmap <down> j
" These don't work nice with nowrap, though
"noremap 0 g0
"noremap $ g$

nmap <leader>st :call ScreenTitle()<cr>

" Quick toggle of hls
nmap /// :set hls!<cr>

" Makes the Alternate plugin (a.vim) easier for Dvorak
command! Z A

" A command to advance to the next vimdiffem'd file.
command! Go diffo|on|n|Gdiff
command! Gop diffo|on|prev|Gdiff

" unicode length, from https://github.com/gregsexton/gitv/pull/14
if exists("*strwidth")
  "introduced in Vim 7.3
  fu! StringWidth(string)
    return strwidth(a:string)
  endfu
else
  fu! StringWidth(string)
    return len(split(a:string,'\zs'))
  endfu
end

function! WindowWidth()
  let pad = 2

  " Calc existence of sign column
  redir => signs
  exec "silent sign place buffer=".bufnr('%')
  redir END
  if match(signs, '\n    line') >= 0
    let signColumn = 2
  else
    let signColumn = 0
  endif

  return winwidth(0) - &fdc - &number*&numberwidth - signColumn - pad
endfunction

function! BFoldtextRealz(foldstart, foldend)
    let lines = a:foldend - a:foldstart
    let firstline = getline(a:foldstart)
    let textend = '|' . lines . '| '

    return firstline . repeat(" ", WindowWidth()-StringWidth(firstline.textend)) . textend
endfunction
function! BFoldtext()
    return BFoldtextRealz(v:foldstart, v:foldend)
endfunction

func! s:emptyFile(fname)
    return getfsize(a:fname) == 0 && !isdirectory(a:fname)
endfunc

function! WordCount()
    let l:old_status = v:statusmsg
    let l:position = getpos(".")
    exe ":silent normal g\<c-g>"
    let l:stat = v:statusmsg
    let l:word_count = 0
    if l:stat != '--No lines in buffer--'
        let l:word_count = str2nr(split(v:statusmsg)[11])
        let v:statusmsg = l:old_status
    end
    call setpos('.', l:position)
    return l:word_count
endfunction

fu! NanoStatus()
    let l:words_today = WordCount()
    let l:words_yesterday = system(
                \ 'git log --pretty=oneline -n 1 '
                \ . '| perl -ne "m%(\d+)/\d+% and print \$1"')
    let l:diff_today = l:words_today - l:words_yesterday
    let l:day_num = str2nr(strftime('%-d'))
    let l:goal_today = printf('%.0f', 50000*l:day_num/30)
    return printf("%d/%d (+%d)", l:words_today, l:goal_today, l:diff_today)
endfu

fu! Nanoize()
    setl statusline=%f%m%r%h%w\%=%{NanoStatus()}
                \\ [L:\%l\ C:\%c\ A:\%b\ H:\x%B\ P:\%p%%]
    call SoftWordWrap()
endfu

fu! SoftWordWrap()
    setl nolist lbr tw=0 wrap
    nmap 0 g0
    nmap $ g$
    noremap g0 0
    noremap g$ $
endfu
command! SoftWordWrap call SoftWordWrap()

fu! ScreenTitle()
    if &term =~ "screen"
        silent exec "!echo -ne '\\ek" . expand("%:t") . " (vim)\\e\\\\'"
    end
endfu

augroup vimrc
    au!
    " Move to last-known position when entering file. See :he 'quote
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    " New file? Immediately start insert mode.
    " NOPE.  This fucks up too many things (e.g. command-t)
    " au BufNewFile * startinsert

    " Empty file? Start insert mode
    au BufEnter * if s:emptyFile(expand("%")) | star | endif

    au BufEnter ~/src/Elm/* setl ts=8 noet noeol
    au BufEnter ~/src/serenade.js/*.coffee setl sw=2
    au BufEnter ~/src/angular-phonecat/* setl sw=2

    " Reset compiler in case the file was renamed, since compiler has the
    " filename hardcoded thanks to vim-coffee-script making nearsighted
    " accomodations for mis-named files.
    au BufWrite ~/LoByMyHand/*.coffee compiler coffee|silent make

    " call SoftWordWrap() |
    au BufRead *Nanowrimo/nanowrimo.txt nmap ,c :echo NanoStatus()<cr>
                \|setl tw=72 fo+=a fp=par
                \|ru autocorrect.vim | ru dvorak.vim

aug END

" This needs to be better... needs to reuse quickfix buffer.
"aug qf
"    au!
"    au QuickFixCmdPre * tabnew
"aug END

"hi!  clear SpecialKey
"hi! SpecialKey ctermfg=160 ctermbg=240

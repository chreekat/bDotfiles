" Vundle nonsense. Probably unnecessary.
" Note that 'nocompatible' sets 'viminfo'
set nocompatible
filetype off

let vundle = $HOME . "/.vim/bundle/Vundle.vim"
if isdirectory(vundle)
    let &rtp .= "," . vundle
    let g:vundle_default_git_proto = 'git'
    call vundle#begin()

    Plugin 'chreekat/vim-colors-lunatic'

    Plugin 'nacitar/a.vim'
    Plugin 'chrisbra/NrrwRgn'
    Plugin 'godlygeek/tabular'
    Plugin 'ivalkeen/vim-simpledb'
    Plugin 'junegunn/goyo.vim'
    Plugin 'junegunn/vim-easy-align'
    " Plugin 'junegunn/vim-peekaboo'
    Plugin 'kchmck/vim-coffee-script'
    Plugin 'kergoth/vim-hilinks'
    Plugin 'ctrlpvim/ctrlp.vim'
    Plugin 'mbbill/undotree'
    Plugin 'msanders/snipmate.vim'
    Plugin 'pbrisbin/vim-syntax-shakespeare'
    Plugin 'pgilad/vim-skeletons'
    Plugin 'romainl/Apprentice'
    Plugin 'romainl/vim-tinyMRU'
    Plugin 'rstacruz/sparkup'
    Plugin 'Shougo/vimproc.vim'
    Plugin 'SirVer/ultisnips'
    Plugin 'timcharper/textile.vim'
    Plugin 'tpope/vim-abolish'
    Plugin 'tpope/vim-characterize'
    Plugin 'tpope/vim-commentary'
    Plugin 'tpope/vim-eunuch'
    Plugin 'tpope/vim-fugitive'
    Plugin 'tpope/vim-obsession'
    Plugin 'tpope/vim-repeat'
    " Plugin 'tpope/vim-sleuth'
    Plugin 'tpope/vim-surround'
    Plugin 'tpope/vim-flagship'
    Plugin 'tpope/vim-unimpaired'
    Plugin 'vim-pandoc/vim-pandoc-syntax'
    Plugin 'vim-scripts/VisIncr'
    Plugin 'wellle/targets.vim'
    " required!
    Plugin 'VundleVim/Vundle.vim'
else
    echomsg "Vundle not installed! Hecka weirdness may ensue."
endif
set rtp+=~/LoByMyHand/vim-simple-md
set rtp+=~/src/vim-tmuxify
set rtp+=~/src/vim-colors-solarized
set rtp+=~/LoByMyHand/vimin

call vundle#end()
filetype plugin on
syn enable

ru macros/matchit.vim

""
"" PLUGIN CONFIG
""

let g:nrrw_rgn_vert = 1
let g:undotree_SetFocusWhenToggle = 1

""
"" COLORSCHEME
""

if isdirectory($HOME."/.vim/bundle/vim-colors-lunatic")
    colorscheme lunatic
else
    echomsg "Skipping colorscheme cause it's no-findings."
endif

let g:is_bash = 1
let g:mapleader = "-"

""
"" SETTINGS
""

set ai
" set cpo+=J
set cpo+=nM
set dict=/usr/share/dict/words
set diffopt+=vertical
set equalalways!
set et
set fillchars+=stl:⬧,stlnc:⬦,vert:⬦,fold:\ 
set fo+=l
set foldtext=BFoldtext()
set foldopen=
set history=100000
set joinspaces!
" set gp=ack-grep\ -H\ --column
set gp=rg\ --vimgrep
set grepformat=%f:%l:%c:%m
set hidden
set modeline
set is
" SO MUCH BETTER
set isfname-==
set laststatus=2 " Always show status
set list
set lcs=tab:┊\ ,trail:·,extends:<,precedes:>
set mouse=
set path=**/,, " Defaults include /usr/include, no thanks
set showbreak=↪
set showcmd
set sidescroll=1
"set sidescrolloff=3
set splitbelow
set splitright
" set statusline=%f%m%r%h%w\%=[L:\%l\ C:\%c\ P:\%p%%]
set nosol
set sw=4
set swb=useopen
set ttimeoutlen=20
set titlestring=vi:\ %t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
set tw=75
set updatetime=2000
" No bell
set vb t_vb=
set wildmode=list:longest,full
set wildignore+=*.o,*.hi,dist
"set wiw=40 nowrap " For shoots and googles
" let &wiw = &tw + 4
set whichwrap=<,>,[,] " arrow keys wrap
if has("persistent_undo")
    set undodir=~/.vim/undos
    set undofile
endif

let g:tex_flavor="latex"
let g:Tex_DefaultTargetFormat="pdf"

let g:haddock_browser = "/usr/bin/google-chrome"
let g:haddock_indexfiledir = "~/.vim"

""
"" MAPPINGS
""

" easy-align
xmap <leader>a <Plug>(EasyAlign)
nmap <leader>a <Plug>(EasyAlign)

" Find a long line
nnoremap <leader>l :call search('^.\{81,}')
nnoremap <leader>L :call search('^.\{81,}', 'b')

" CtrlP maps
nnoremap <leader>f :CtrlP<cr>
nnoremap <leader>b :CtrlPBuffer<cr>

" Show lines we've jumped to (helps with folds)
" But, no: 1. hides "SEARCH WRAPPED" message. 2. "press enter to continue"
" nnoremap n n:echo getline('.')<cr>
" nnoremap N N:echo getline('.')<cr>
" nnoremap # #:echo getline('.')<cr>
" nnoremap * *:echo getline('.')<cr>

" Heads on stakes! Don't do this!
" You always think it's a good idea, but it isn't.
"nnoremap <c-p> <c-w>h
"nnoremap <c-j> <c-w>j
"nnoremap <c-k> <c-w>k
"nnoremap <c-n> <c-w>l

noremap <leader>v :vsp<cr>

" When I replace text in visual mode (v_p), I rarely ever care more about
" what's being replaced than I do what I'm replacing with.
vnoremap p "0p
" Unless I do
vnoremap <leader>p p

" I never want ex mode.
nmap Q <nop>

noremap <leader>xo :!xdg-open %<cr><c-l>

noremap <F5> :UndotreeToggle<cr>

nnoremap <Leader>V :tabe  ~/LoByMyHand/bDotfiles/vimrc<cr>
nnoremap <Leader>S :so ~/.vimrc<cr>
nnoremap <Leader>L :tabe ~/LoByMyHand/bDotfiles/vim/bundle/vim-colors-lunatic/colors/lunatic.vim<cr>

" Make <c-s> useful!
noremap <c-s> :up<cr>
vnoremap <c-s> :w
inoremap <c-s> <esc>:up<cr>

" Adds C-u to the undo stream:
inoremap <C-u> <esc>S

nnoremap <C-w>M <C-w>\|<C-w>_

nmap <leader>u :windo update<cr>

" Swap two words, like <m-t> in emacs
nmap \t l2bdiw"_xea<space><esc>p

" There is never a time I don't want this, I believe.
"noremap j gj
"noremap k gk
"imap <up> <c-o>k
"imap <down> <c-o>j
"nmap <up> k
"nmap <down> j
" These don't work nice with nowrap, though
"noremap 0 g0
"noremap $ g$

" Quick toggle of hls
function! ToggleHighlight()
    set hls!
    if &hls
        let @/ = input("Search: ", @/)
    endif
endfunction

" Try to get useful linenumbers?
" Doh, ? and / also use cmap. Need to set a buflocal var maybe.
"nnoremap : :set nu<cr>:
"cnoremap <cr> <home>set nonu\|<cr>

" Insert today's date.
inoremap <F9> <c-r>=system("ddate -1")<cr>
" Insert the time
inoremap <F10> <c-r>=system("ddate -t")<cr>

"
" Commands
"

" Trim whitespace thx
command! -range Trim <line1>,<line2>s/\s\+$//

" The "Dominate Dragons" idea
command! GQ silent Gcommit -am "quicksave"

" Makes the Alternate plugin (a.vim) easier for Dvorak
command! Z A

" Function for turning space-indenting into tab-indenting
function! SpaceToTab(numSpaces) range
    let scmd = a:firstline . "," . a:lastline . "s/^\\(\\%(@@\\)*\\)@@/\\1\\t"
    let spaces = ""
    let i = a:numSpaces
    while i > 0
        let spaces .= " "
        let i = i - 1
    endwhile
    let scmd = substitute(scmd, "@@", spaces, "g")
    try
        while 1
            sil exec scmd
        endwhile
    catch /^Vim\%((\a\+)\)\=:E486/
    endtry
endfunction

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

" I apologize for this name.
function! BFoldtextRealz(foldstart, foldend)
    let lines = a:foldend - a:foldstart
    let commentPat = substitute(&cms, '%s', '.*', '')

    let firstline=getline(a:foldstart)
    " Now, a bunch of replacements/removals
    "   End-of-line Comments
    let firstline = substitute(firstline, '\S\+\zs\s*'.commentPat, '', 'g')
    "   Syntactic white noise
    let firstline = substitute(firstline, '^class\s*', '', 'g')
    "   Fold markers at end of line
    let firstline = substitute(firstline, '\s*{{{\d*$', '', '')

    let textend = '  |' . lines . '| ↓' . v:foldlevel . ' '

    " Now, chop off as much of the firstline as necessary to show the fold info.
    let windowWidth = WindowWidth() " min([WindowWidth(), 80])
    let lineWidth = StringWidth(firstline)
    let endWidth = StringWidth(textend)

    if windowWidth < (lineWidth + endWidth) && windowWidth > endWidth
        let firstline = strpart(firstline, 0, windowWidth - endWidth - 1)
        let firstline .= "…"
    endif

    return firstline
                \ . repeat(" ", windowWidth-StringWidth(firstline.textend))
                \ . textend
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

fu! NanoStats()
    let l:day_num = str2nr(strftime('%-d'))
    let l:goal = 50000.0

    "let l:goal_today = float2nr(ceil(50000.0*l:day_num/30) + 0.01)
    let l:daily_goal = l:goal / 30
    let l:goal_today = l:goal * l:day_num / 30

    let l:words_today = WordCount()
    let l:words_yesterday = system(
                \ 'git log --before=0:00 --pretty=oneline -n 1 '
                \ . '| perl -ne "m%(\d+)/\d+% and print \$1"')
    let l:diff_today = l:words_today - l:words_yesterday

    let l:daily_pct = 100 * l:diff_today / l:daily_goal
    let l:pct_today = 100 * l:words_today / l:goal_today
    let l:pct = 100 * l:words_today / l:goal

    return {
          \ 'diff_today': l:diff_today,
          \ 'daily_pct': l:daily_pct,
          \ 'words_today': l:words_today,
          \ 'goal_today': l:goal_today,
          \ 'pct_today': l:pct_today,
          \ 'words_yesterday': l:words_yesterday,
          \ 'pct': l:pct
          \ }
endfu

fu! NanoStatus()

    let l:stats = NanoStats()
    return printf(
                \ '+%.0f(%.2f%%) today, %.0f/%.0f(%.2f%%) to date, %.2f%% overall',
                \ l:stats.diff_today, l:stats.daily_pct,
                \ l:stats.words_today, l:stats.goal_today,
                \ l:stats.pct_today,
                \ l:stats.pct)
endfu

fu! NanoDayPct(yesterday)
    if !exists("b:nanoDayPct")
        let b:nanoDayPct = "--"
    endif

    if index(["n", "i"], mode()) < 0
        return b:nanoDayPct
    endif

    let l:pct = 100 * (WordCount() - a:yesterday) / 1667
    let l:res = printf("%d%%", l:pct - l:pct % 5)
    let b:nanoDayPct = l:res
    return l:res
endfu

fu! Nanoize()
    let l:stats = NanoStats()
    let b:words_yesterday = l:stats.words_yesterday
    setl statusline=%<%f\ [%{NanoDayPct(b:words_yesterday)}]\ %h%m%r%=%-14.(%l,%c%V%)\ %P
endfu

fu! SoftWordWrap()
    setl lbr nolist tw=99999999999999999 wrap sbr= fo-=a
    noremap <buffer> 0 g0
    noremap <buffer> $ g$
    noremap <buffer> g0 0
    noremap <buffer> g$ $
    noremap <buffer> j gj
    noremap <buffer> k gk
    noremap <buffer> G G$g0
    nmap <buffer> D d$
    nmap <buffer> dd 0D
    " Disabling formatting!
    noremap <buffer> gw <nop>
    noremap <buffer> gq <nop>

endfu
command! SoftWordWrap call SoftWordWrap()

" This is adapted from
" http://vim.wikia.com/wiki/Windo_and_restore_current_window
function! KeepWin(command)
  let currwin=winnr()
  execute a:command
  execute currwin . 'wincmd w'
endfunction

augroup vimrc
    au!
    " Move to last-known position when entering file. See :he 'quote
    " au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    " New file? Immediately start insert mode.
    " NOPE.  This fucks up too many things (e.g. command-t)
    " au BufNewFile * startinsert

    au BufEnter ~/src/Elm/* setl ts=8 noet noeol
    au BufEnter ~/src/serenade.js/*.coffee setl sw=2
    au BufEnter ~/src/angular-phonecat/* setl sw=2
    au BufEnter ~/src/tasty/* setl sw=2
    au BufEnter *.hamlet setl sw=2
    au BufEnter,BufNewFile *.md setf markdown
    au BufEnter,BufNewFile .ghci setf haskell

    " Reset compiler in case the file was renamed, since compiler has the
    " filename hardcoded thanks to vim-coffee-script making nearsighted
    " accomodations for mis-named files.
    "au BufWrite ~/LoByMyHand/*.coffee compiler coffee|silent make

    " call SoftWordWrap() |
    au BufRead nanowrimo.txt nmap ,ct :echo NanoStatus()<cr>
                \|nmap ,Cc :exec 'Gcom -m "' . escape(NanoStatus(), '%') . '" %'<cr>
                \|nmap ,Ca :exec 'Gcom --amend -m "' . escape(NanoStatus(), '%') . '" %'<cr>
                \|setl tw=72 fo+=a fp=par
                \|call Nanoize()
                " \|ru autocorrect.vim | ru dvorak.vim

    au BufNewFile ~/Dropbox/Project_Euler/p*.lhs :0r <abuf>:h/problem.skel |4
    au BufNewFile *.html.hs :0r ~/.vim/skel/html.hs |$
    au BufNewFile *.html :0r ~/.vim/skel/html
    " au BufNewFile *.hamlet :0r ~/.vim/skel/hamlet
    au BufNewFile ~/bin/* :0r ~/.vim/skel/bin | setf sh | 5
    au BufRead Doxyfile :map <buffer> ,\ :!doxygen<cr><c-l>

    "au WinLeave * setl nowrap
    "au WinEnter * if !&scrollbind|setl wrap|endif

    " These are reached via codex tags and I don't care to track the
    " buffers.
    au BufEnter ~/.cabal/packages/hackage.haskell.org/* setl nobuflisted buftype=nowrite
aug END

func! Typewriter()
    if !exists('b:typewriter_mode')
        imap <buffer> <c-w> <nop>
        imap <buffer> <bs> <nop>
        map <buffer> x <nop>
        map <buffer> d <nop>
        map <buffer> c <nop>
        map <buffer> s <nop>
        map <buffer> S <nop>
        map <buffer> D <nop>
        map <buffer> C <nop>
        let b:typewriter_mode=1
    else
        imapclear <buffer>
        mapclear <buffer>
        unlet b:typewriter_mode
    endif
endfunction

com! Typewriter call Typewriter()

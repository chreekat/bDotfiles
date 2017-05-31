call plug#begin('~/.vim/bundle')
    Plug 'chrisbra/NrrwRgn', { 'on': 'NR' }
    Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
    Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
    Plug 'tpope/vim-abolish'
    Plug 'tpope/vim-eunuch'
    Plug 'tpope/vim-flagship'
    Plug 'tpope/vim-fugitive'
    Plug 'ultimatecoder/goyo-doc'
    Plug '~/LoByMyHand/vim-simple-md'
    Plug '~/LoByMyHand/passhole'
    Plug '~/LoByMyHand/vimin'
    Plug 'vim-scripts/VisIncr'
call plug#end()

""
"" C O N F I G U R A T I O N
""

"" Sane defaults
set expandtab
set formatoptions+=j
set hidden
set modeline
" ^ Debian apparently resets modeline, which is on by vim default
set showcmd
set ttimeoutlen=20
if has("persistent_undo")
    set undodir=~/.vim/undos
    set undofile
endif
set wildignore+=*.o,*.hi,dist,*.dyn_o,*.dyn_hi,.git,.stack-work
set wildmode=list:longest,full
runtime shifted_fkeys.vim

"" My preferences
filetype indent off
set splitbelow
set splitright

set foldopen=
set incsearch
set nojoinspaces
set pastetoggle=<F2>
set path=.,,**
" Make s a synonym for z, which I always mistype
nmap s z
nmap ss zz

"" My plugin preferences
let g:goyo_width = 84
let g:undotree_WindowLayout = 4

"" In the absence of file- or filetype-specific options, these are the defaults
"" I want.
let g:is_bash=1
set autoindent
set shiftwidth=4
set textwidth=80
set formatoptions+=nl

""
"" Tool integrations
""
set grepprg=rg\ -H\ --vimgrep
set grepformat=%f:%l:%c:%m,%f:%l:%m

""
"" Behavior tweaks
""

" Make zM take a count, like G, setting an absolute foldlevel.
nnoremap zM :<c-u>let &foldlevel=v:count<cr>

" Make [[ and ]] support { being somewhere other than column 1
nnoremap [[ :call search('^\S\&.*{$', 'bsW')<cr>
nnoremap ]] :call search('^\S\&.*{$', 'sW')<cr>

""
"" S H O R T C U T S
""

" (Note pastetoggle=<F2>)

" Jump to vimrc
nnoremap <F3> :tabe ~/.vimrc<cr>

" Open the undotree
nnoremap <F5> :UndotreeToggle<cr>

" Insert today's date, in two formats
inoremap <F9> <c-r>=system("date +%Y-%m-%d $@ \| perl -pe chomp")<cr>
inoremap <S-F9> <c-r>=system("date +%Y%m%d $@ \| perl -pe chomp")<cr>

" Insert the time
inoremap <F10> <c-r>=system("date +%H:%M $@ \| perl -pe chomp")<cr>
" Both! :D
imap <F11> <F9>T<F10>

" Unimpaired-inspired maps
nnoremap ]q :cnext<cr>
nnoremap [q :cprev<cr>
nnoremap ]j :lnext<cr>
nnoremap [j :lprev<cr>


nmap ]<space> <f2>o<esc><f2>'[
nmap [<space> <f2>O<esc><f2>
" ^ Uses pastetoggle

nnoremap >P ]P>']
nnoremap >p ]p>']

" Paste-and-format, returning to the top (as p and P do normally)
nmap >q >p']gq'[
nmap >Q >P']gq'[

" Trim whitespace thx
command! -range Trim <line1>,<line2>s/\s\+$//
command! TRIM %Trim


""
"" O T H E R   C O N F I G U R A T I O N
"" 

"" FILE SPECIFIC SETTINGS
augroup vimrc
    au!
    au BufRead ~/.hledger.journal runtime hledger-main-journal.vim
    au BufRead ~/IN.in call system("tmux setw automatic-rename")
    au BufUnload ~/IN.in call system("tmux setw automatic-rename")
augroup END

"" GLOBAL AUTOCMDS
augroup vimrc_global
    au!
    " Create a global 'last insert' mark
    au InsertLeave * normal mZ
augroup END

""
"" Scheme Usability Tweaks
""
"" These don't change the scheme so much as the UI.
function! s:vimrc_highlighting()
    hi clear DiffText
    hi clear Folded
    hi Folded ctermfg=16777200
    hi Search ctermbg=404055
    hi MatchParen ctermfg=14 ctermbg=0
endfunction
augroup vimrc_highlighting
    au!
    au ColorScheme * call s:vimrc_highlighting() 
augroup END
doautocmd ColorScheme

""
"" Things that should be plugins?
""

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

" Flatten for export
noremap -f :g/./,/^$/join<cr>
ounmap -f

" Prompt for missing files with 'gf'
"
" Note gf takes a long-ass time if path includes ** and you run it somewhere
" with a deep directory tree. What's the best solution there? Restrict path
" before running gf? Use a timeout?
" TODO: This doesn't use includeexpr
function! GFPrompt()
    try
        normal! gf
    catch /^Vim\%((\a\+)\)\=:E447/
        if confirm("Not found. Create " . expand("<cfile>:p") . "?", "&no\n&yes") == 2
            let l:dir = expand("<cfile>:p:h")
            if !isdirectory(l:dir)
                call mkdir(l:dir, "p")
            endif
            edit <cfile>
        endif
    endtry
endfunction
nnoremap gf :call GFPrompt()<cr>

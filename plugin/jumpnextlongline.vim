" Jump Next Long Line
" ===================
"
" Vim plugin to jump to the next line that exceed the textwidth setting
" Last Change: 2018 Dec 26
" Maintainer: Caio Romão <caioromao@gmail.com>
" License: This file is placed in the public domain
"
" Mappings:
"   <Leader>l or <Plug>JumpNextLongLine
"       Jumps to the next (too) long line
"
" This plugin doesn't have any settings.

if exists("g:loaded_JumpNextLongLine") || &cp
  finish
endif

let g:loaded_JumpNextLongLine= 1
let s:save_cpo = &cpo
set cpo&vim

if !hasmapto('<Plug>JumpNextLongLine')
    nmap <silent> <unique> <Leader>l <Plug>JumpNextLongLine
endif

noremap <unique> <script> <Plug>JumpNextLongLine :call <SID>JumpNext()<CR>

function! s:JumpNext()
    let nline = s:NextLongLine()
    if nline > 0
        execute "normal! " . nline . "gg"
    endif
endfunction

function! s:IsLineTooLong(lineNr)
    let treshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let len = strlen(substitute(getline(a:lineNr), '\t', spaces, 'g'))
    if len > treshold
        return 1
    endif
endfunction

function! s:NextLongLine()
    let curline = line('.')
    let lastline = line('$')

    let i = curline + 1
    " Scan to the end of the file
    while i <= lastline
        if s:IsLineTooLong(i)
            return i
        endif
        let i += 1
    endwhile
    " Nothing found: scan from the beginning
    let i = 1
    while i <= curline
        if s:IsLineTooLong(i)
            return i
        endif
        let i += 1
    endwhile
    return 0
endfunction

let &cpo = s:save_cpo

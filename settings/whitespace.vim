"white space visible
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
noremap <leader><F9> :set list!<CR>
inoremap <leader><F9> <C-o>:set list!<CR>
cnoremap <leader><F9> <C-c>:set list!<CR>

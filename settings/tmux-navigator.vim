
if !has('nvim')
    let g:tmux_navigator_no_mappings = 1
    nnoremap <silent> <ctrl-h> :TmuxNavigateLeft<cr>
    nnoremap <silent> <ctrl-j>  :TmuxNavigateDown<cr>
    nnoremap <silent> <ctrl-k> :TmuxNavigateUp<cr>
    nnoremap <silent> <ctrl-l> :TmuxNavigateRight<cr>
    nnoremap <silent> <ctrl-\> :TmuxNavigatePrevious<cr>
endif

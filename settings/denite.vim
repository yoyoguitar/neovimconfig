" Author        : teshler
" Created       : 15/04/2020
" License       : MIT
" Description   : 

"denite settings
"if has('nvim')
  " reset 50% winheight on window resize
  "augroup deniteresize
  "  autocmd!
  "  autocmd VimResized,VimEnter * call denite#custom#option('default',
  "        \'winheight', winheight(0) / 2)
  "augroup end

  call denite#custom#option('default', {
        \ 'prompt': '❯',
        \ 'auto_resize': v:true,
        \ 'start_filter': v:true,
        \ 'split': 'floating'
        \ })
  call denite#custom#option('_', 'statusline', v:false)


  call denite#custom#var('file/rec', 'command',
	\ ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--hidden','--vimgrep', '--no-heading', '-S'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  "  call denite#custom#map('insert', '<Esc>', '<denite:enter_mode:normal>',
  "        \'noremap')
  "  call denite#custom#map('normal', '<Esc>', '<NOP>',
  "        \'noremap')
  "  call denite#custom#map('insert', '<C-v>', '<denite:do_action:vsplit>',
  "        \'noremap')
  "  call denite#custom#map('normal', '<C-v>', '<denite:do_action:vsplit>',
  "        \'noremap')
  "  call denite#custom#map('insert', '<C-s>', '<denite:do_action:split>',
  "        \'noremap')
  "  call denite#custom#map('normal', '<C-s>', '<denite:do_action:split>',
  "        \'noremap')
  "  call denite#custom#map('insert', '<C-t>', '<denite:do_action:tabopen>',
  "        \'noremap')
  "  call denite#custom#map('normal', '<C-t>', '<denite:do_action:tabopen>',
  "        \'noremap')
  "  call denite#custom#map('normal', 'dw', '<denite:delete_word_after_caret>',
  "        \'noremap')
  "  call denite#custom#map(
  "	      \ 'insert',
  "	      \ '<Down>',
  "	      \ '<denite:move_to_next_line>',
  "	      \ 'noremap'
  "	      \)
  "  call denite#custom#map(
  "	      \ 'insert',
  "	      \ '<Up>',
  "	      \ '<denite:move_to_previous_line>',
  "	      \ 'noremap'
  "	      \)
  "
    autocmd FileType denite call s:denite_my_settings()
    function! s:denite_my_settings() abort
      nnoremap <silent><buffer><expr> <CR>
	  \ denite#do_map('do_action')
	  nnoremap <silent><buffer><expr> d
	  \ denite#do_map('do_action', 'delete')
	  nnoremap <silent><buffer><expr> p
	  \ denite#do_map('do_action', 'preview')
	  nnoremap <silent><buffer><expr> q
	  \ denite#do_map('quit')
	  nnoremap <silent><buffer><expr> i
	  \ denite#do_map('open_filter_buffer')
	  nnoremap <silent><buffer><expr> <ESC> 
	  \ denite#do_map('open_filter_buffer')
	  nnoremap <silent><buffer><expr> <Space>
	  \ denite#do_map('toggle_select').'j'
	  nnoremap <silent><buffer><expr><C-s>
	  \ denite#do_map('do_action','split')
	  nnoremap <silent><buffer><expr><C-v>
	  \ denite#do_map('do_action','vsplit')
	  nnoremap <silent><buffer><expr><C-t>
	  \ denite#do_map('do_action','tabopen')
    endfunction 
	autocmd FileType denite-filter call s:denite_filter_my_settings()
	function! s:denite_filter_my_settings() abort
	  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
	  imap <silent><buffer> <ESC> <Plug>(denite_filter_quit)
	endfunction
"endif

map <C-p>Denite file/rec -root-markers=.git<CR>
nnoremap <silent> <expr> <c-p> (expand('%') =~ 'chadtree' ? "\<c-w>\<c-w>" : '').":DeniteProjectDir file/rec -root-markers=.git\<cr>"
nnoremap <leader>s :<C-u>Denite buffer<CR>
nnoremap <leader>c :<C-u>Denite change<CR>
"TODO uncomment this if we actually add a tag engine
"nnoremap <leader>T :<C-u>Denite tag<CR> 
"nnoremap <leader>t :<C-u>DeniteCursorWord tag -root-markers=.git<CR>
nnoremap <leader><Space>s :<C-u>DeniteBufferDir buffer<CR>
nnoremap <leader>8 :<C-u>DeniteCursorWord grep:. -root-markers=.git<CR>
nnoremap <leader>/ :<C-u>Denite grep:. -root-markers=.git<CR>
"nnoremap <leader>g :<C-u>DeniteProjectDir grep:. -root-markers=.git<CR>
nnoremap <leader><Space>/ :<C-u>DeniteBufferDir grep:. -root-markers=.git<CR>
nnoremap <leader>d :<C-u>DeniteBufferDir file/rec -root-markers=.git<CR>

hi link deniteMatchedChar Special

" denite-extra

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

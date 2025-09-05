" Author        : teshler
" Created       : 15/04/2020
" License       : MIT
" Description   : 
"
"
" ligthline setup
let g:lightline#ale#indicator_checking = "\uf1ce"
let g:lightline#ale#indicator_warnings = " \uf071 "
let g:lightline#ale#indicator_errors = " \uf05e "
let g:lightline#ale#indicator_ok = "\uf00c"

let g:lightline = {
	      \ 'active': {
	      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ]],
	      \   'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ], ['lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ]]
	      \ },
	      \ 'component_function': {
	      \   'fugitive': 'LightlineFugitive',
	      \   'filename': 'LightlineFilename',
	      \   'fileformat': 'LightlineFileformat',
	      \   'filetype': 'LightlineFiletype',
	      \   'fileencoding': 'LightlineFileencoding',
	      \   'mode': 'LightlineMode',
	      \ },
	      \ 'subseparator': { 'left': '|', 'right': '|' },
          \ 'component_expand': {
          \  'linter_checking': 'lightline#ale#checking',
          \  'linter_warnings': 'lightline#ale#warnings',
          \  'linter_errors': 'lightline#ale#errors',
          \  'linter_ok': 'lightline#ale#ok',
          \ },
          \ 'component_type':  {
          \     'linter_checking': 'warning',
          \     'linter_warnings': 'warning',
          \     'linter_errors': 'error',
          \     'linter_ok': 'left',
          \ },
          \ 'colorscheme': 'powerline'
	      \ }
function! LightlineFugitive()
  try
	  if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &filetype !~? 'vimfiler' && exists('*fugitive#head')
		  let l:mark = ''  " edit here for cool mark
		  let l:branch = fugitive#head()
		  return l:branch !=# '' ? l:mark.branch : ''
	  endif
  catch
  endtry
  return ''
endfunction

function! LightlineFileformat()
	let l:fileFormat = winwidth(0) > 70 ? &fileformat : ''
	let l:status = '' != LspStatus() ? ' '. LspStatus() : ''
	return l:status . ' ' . l:fileFormat
endfunction

function! LightlineFiletype()
	return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineModified()
  return &filetype =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &filetype !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightlineCurrentFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

function! LightlineFilename()
	let l:fname = expand('%:t')

    let l:currentFileName = 'Tagbar'
    if has_key(g:lightline,fname)
         set l:currentFileName = g:lightline.fname
    endif
    return l:fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
		\ l:fname =~ 'Tagbar' ? l:currentFileName :
		\ l:fname =~ '__Gundo\|NERD_tree' ? '' :
		\ &filetype == 'vimfiler' ? vimfiler#get_status_string() :
		\ &filetype == 'denite' ? denite#get_status("mode") :
		\ &filetype == 'vimshell' ? vimshell#get_status_string() :
		\ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
		\ ('' != LightlineCurrentFilename() ? LightlineCurrentFilename() : '[No Name]') .
		\ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction


"light line
function! LightlineMode()
	let l:fname = expand('%:t')
	return l:fname =~ 'Tagbar' ? 'Tagbar' :
	  \ l:fname =~ 'ControlP' ? 'CtrlP' :
	  \ l:fname =~ '__Gundo__' ? 'Gundo' :
	  \ l:fname =~ '__Gundo_Preview__' ? 'Gundo Preview' :
	  \ l:fname =~ 'NERD_tree' ? 'NERDTree' :
	  \ &filetype == 'unite' ? 'Unite' :
	  \ &filetype == 'vimfiler' ? 'VimFiler' :
	  \ &filetype == 'vimshell' ? 'VimShell' :
	  \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction
"end light line setup


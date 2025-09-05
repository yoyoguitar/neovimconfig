let g:vimspector_base_dir=$HOME.'/.config/nvim/bundle/vimspector'
let g:vimspector_install_gadgets = [ 'debugpy' ]
let g:vimspector_code_minwidth = 120
nmap <F1> :VimspectorReset<CR>
nmap <F5> <Plug>VimspectorContinue
nmap <F3> <Plug>VimspectorStop
nmap <F4> <Plug>VimspectorRestart
nmap <F6> <Plug>VimspectorPause
nmap <F9> <Plug>VimspectorToggleBreakpoint
nmap <F2> <Plug>VimspectorToggleConditionalBreakpoint
nmap <F7> <Plug>VimspectorBalloonEval
xmap <F7> <Plug>VimspectorBalloonEval
nmap <F8> <Plug>VimspectorRunToCursor
nmap <F10>	<Plug>VimspectorStepOver
nmap <leader><F10>	<Plug>VimspectorStepInto
nmap <F12>	<Plug>VimspectorStepOut
packadd! vimspector

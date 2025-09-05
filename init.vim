set nocompatible              " be iMproved, required

if !has('gui_running')
  set t_Co=256
endif

let g:python3_host_prog= $HOME.'/.pyenv/shims/python3'

" we set the the number of threads vimplug can use down to 8, otherwise git
" times out with some requests
let g:plug_threads= 8

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !git clone https://github.com/junegunn/vim-plug.git ~/.config/nvim/vim-plug
  silent !mkdir -p ~/.config/nvim/autoload
  silent !ln -s ~/.config/nvim/vim-plug/plug.vim ~/.config/nvim/autoload/
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

if empty(glob('~/.config/nvim/pack/vender/opt/vimspector'))
	silent !mkdir -p ~/.config/nvim/pack/vendor/opt
	silent !ln -s ~/.config/nvim/bundle/vimspector ~/.config/nvim/pack/vendor/opt 
endif

" base url that allows us to pull everything from mirrored repors in our
" network
let g:git_base_url= 'https://github.com/'

call plug#begin('~/.config/nvim/bundle')

"
"
""lsp setup
Plug g:git_base_url.'neovim/nvim-lspconfig', { 'tag': '*' }
Plug g:git_base_url.'hrsh7th/cmp-nvim-lsp'
Plug g:git_base_url.'hrsh7th/cmp-buffer'
Plug g:git_base_url.'hrsh7th/cmp-path'
Plug g:git_base_url.'hrsh7th/cmp-cmdline'
Plug g:git_base_url.'hrsh7th/nvim-cmp'
" salt lsp server
Plug g:git_base_url.'vmware-archive/salt-vim'
"java lsp server
Plug g:git_base_url.'mfussenegger/nvim-jdtls', { 'tag': '*' }

" For vsnip users.
Plug g:git_base_url.'hrsh7th/cmp-vsnip'
Plug g:git_base_url.'hrsh7th/vim-vsnip'

"Plug 'windwp/nvim-autopairs'

" status line control
Plug g:git_base_url.'nvim-lua/lsp-status.nvim.git'
"

" nvim-tree (nerd tree like plug in)
Plug g:git_base_url.'nvim-tree/nvim-tree.lua.git', { 'tag': 'v1.3' }

"vim tmux navigator
Plug g:git_base_url.'christoomey/vim-tmux-navigator.git'

"dev iconds
Plug g:git_base_url.'ryanoasis/vim-devicons.git'

"Denite (ctrl-P but better)
"denite doesn't work with latest nvim, need to find new replacement
"Plug g:git_base_url.'Shougo/denite.nvim', { 'tag': '*', 'do': ':UpdateRemotePlugins' }
"
"Vista (tagbar like support)
Plug g:git_base_url.'liuchengxu/vista.vim'

"Light line support for better status var
Plug g:git_base_url.'itchyny/lightline.vim.git'

Plug g:git_base_url.'tpope/vim-fugitive.git'

"Vimspector visual debug tool
Plug g:git_base_url.'puremourning/vimspector.git', { 'tag': '*', 'do': ':VimspectorInstall --verbose' }

"mini.nivm
" enable mini plugins in your '~/.mynvimrc' file
" see '~/.config/nvim/settings/mini.vim' for examples
Plug g:git_base_url.'echasnovski/mini.nvim', { 'tag': '*' }

" source your own plugins in '~/.mynvim_plugins'
" all plugins should be mirrored at
" settings for these plugins should be added to your `~/.mynvimrc' file.
if filereadable(expand('~/.mynvim_plugins'))
  source ~/.mynvim_plugins
endif

"
"" All of your Plugins must be added before the following line
call plug#end()            " required

"source settings for each plugin
source ~/.config/nvim/settings/lsp.vim
source ~/.config/nvim/settings/cmp.vim
source ~/.config/nvim/settings/nvim-tree.vim
source ~/.config/nvim/settings/tmux-navigator.vim
"source ~/.config/nvim/settings/denite.vim
source ~/.config/nvim/settings/vista.vim
source ~/.config/nvim/settings/lightline.vim
source ~/.config/nvim/settings/tabnav.vim
source ~/.config/nvim/settings/tabs.vim
source ~/.config/nvim/settings/fugitive.vim
source ~/.config/nvim/settings/vimspector.vim
source ~/.config/nvim/settings/whitespace.vim
source ~/.config/nvim/settings/mini.vim
source ~/.config/nvim/settings/help.vim
source ~/.config/nvim/settings/spelling.vim

filetype plugin indent on

" sets autoreloading of files if they are changed by another editor
set autoread

" Check for user specific settings in '~/.mynvimrc'
" this is where you can add color schemes and other personalized settings that
" won't be overwritten by salt
" for example: you can put the following in your .mynvimrc to set the color
" scheme (note: you would need to remove the quote chars)
"
"" set termguicolors
"" colorscheme atom
""
if filereadable(expand('~/.mynvimrc'))
  source ~/.mynvimrc
endif

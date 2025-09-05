"map nvim tree toggling
nmap <c-n> :NvimTreeToggle<CR>

lua << EOF
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local function my_on_attach(bufnr)
 local api = require "nvim-tree.api"

 local function opts(desc)
     return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
 end

 -- default mappings
 api.config.mappings.default_on_attach(bufnr)

 -- custom mappings
 vim.keymap.set('n', '<c-V>', api.node.open.vertical, opts('Open: Vertical Split'))
 vim.keymap.set('n', '?',     api.tree.toggle_help, opts('Help'))
end


local usefonts = os.getenv("NVIM_TREE_USE_FONTS")
local setup_config = {
  on_attach = my_on_attach,
  renderer = {
    group_empty = true,
    special_files = {},
      icons = {
        show = {
          folder_arrow = false,
        }, 
      },
    },
  filters = {
    dotfiles = true,
  },
}

if not usefonts then
	setup_config['renderer']['icons']['glyphs']={ 
				 default = "",
         folder = {
            default = ">",
            open = "/",
            empty = ">",
            empty_open = "/",
          },
           git = {
            unstaged = "*",
            staged = "+",
            unmerged = "",
            renamed = "<",
            untracked = "?",
            deleted = "-",
            ignored = "o",
           },
        }
else
	setup_config['renderer']['icons']['glyphs']={
				default = "",
				git = {
            unstaged = "*",
            staged = "+",
            unmerged = "",
            renamed = "<",
            untracked = "?",
            deleted = "-",
            ignored = "o",
						}
				}
end

require("nvim-tree").setup(setup_config)

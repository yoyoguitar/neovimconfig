lua << EOF

-- lsp status
local lsp_status = require('lsp-status')
lsp_status.config({ 
	current_function = true,	
	show_filename = false, 
	diagnostics = true, 
	select_symbol = false,
	status_symbol = ' V',
	kind_labels = {},--vim.g.completion_customize_lsp_label,
		indicator_errors = 'E',
		indicator_warning = 'W',
		indicator_hint = '?',
		indicator_info = 'i',
		indicator_ok = 'Ok',
	})

lsp_status.register_progress()

--local nvim_lsp = require('lspconfig')
--vim.lsp.config()

local log_to_file = function(logfile)
	return function(log_value)
		local file = io.open(logfile, "a")
		if not file then
			file:close()
			return
		end

		file:write(log_value .. "\n")
		file:close()
	end
end


-- servers to disable rename functions
local disabledRename = {
	tsserver = true,
--	jedi_language_server = true
	}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
	lsp_status.on_attach(client)

	if disabledRename[client.name] ~= nil then
	if client.server_capabilities then
		client.server_capabilities.rename = false
	end
	end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap=true, silent=true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	--buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gc', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	-- mapping below disabled to avoid conflicts with window jumping key mapping
	--buf_set_keymap('n', '<A-k>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	-- mapping below disabled to avoid conflicts with window jumping key mapping
	--buf_set_keymap('n', '<A-j>', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
	buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
	buf_set_keymap('n', 'gh', '<cmd>ClangdSwitchSourceHeader<CR>', opts)
	
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- add new servers here


local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local angular_project_library_path = "./node_modules"
local ngserver_cmd = {"./node_modules/@angular/language-server/bin/ngserver", "--stdio", "--tsProbeLocations", angular_project_library_path , "--ngProbeLocations", angular_project_library_path}
local servers = {
		clangd = { 
		handlers = lsp_status.extensions.clangd.setup(),
		cmd={"clangd", "--background-index", "-j=3","--pch-storage=memory","--query-driver=/usr/bin/g++-*,/usr/bin/gcc-*"},
		init_options = {
  		  clangdFileStatus = true
  		},
		single_file_support = false,
		capabilities = { textDocument = { documentSymbol = true }},
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
	},
  cmake = {},
	jedi_language_server = { cmd = { os.getenv("HOME").."/.config/nvim/neovim_venv/bin/jedi-language-server"}},
	jsonls = { 
		capabilities = { textDocument = {completion ={ completionItem = { snippetSupport = true}}}},
		json = { 
			schemas = {
				{
					fileMatch = { ".vimspector.json" },
					url = "https://puremourning.github.io/vimspector/schema/vimspector.schema.json"
				},
				{
					fileMatch = {".gadgets.json", ".gadgets.d/*.json"},
					url = "https://puremourning.github.io/vimspector/schema/gadgets.schema.json"
				}
			}
		}
	},
	angularls = {
		cmd = ngserver_cmd,
		on_new_config = function(new_config,new_root_dir)
			new_config.cmd = ngserver_cmd
		end,
		},
	ts_ls= {},
	yamlls ={ settings= { 
		yaml = {
			schemaStore={enable=true}
		}}},
	lua_ls = { settings = {
		Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT',
					-- Setup your lua path
					path = runtime_path,
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = {'vim'},
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				}
	}}},
	vimls = {},
	cssls = {},
	html = {},
	remark_ls = { settings = { remark = { requireConfig = false }}},
	jdtls = { cmd = {'/usr/local/jdtls/bin/jdtls'} },
	dockerls = {},
	gitlab_ci_ls = { cmd = { '/usr/local/bin/gitlab-ci-ls-linux'}},
	rust_analyzer = {settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
				}}
}

local defaultConfig = {
		on_attach = on_attach,
		capabilities = lsp_status.capabilities, 
		flags = {
			debounce_text_changes = 150,
		}
}


local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
for serverName, config in pairs(servers) do
	local updatedConfig = vim.tbl_deep_extend('keep', config, defaultConfig)
	updatedConfig = vim.tbl_deep_extend('keep',cmp_capabilities, updatedConfig)
	vim.lsp.config(serverName,updatedConfig)
	vim.lsp.enable(serverName)
	--nvim_lsp[serverName].setup(updatedConfig)
end
--vim.lsp.set_log_level("debug")

-- associate gitlab ci with the right file types
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.gitlab-ci*.{yml,yaml}",
	  callback = function()
		    vim.bo.filetype = "yaml.gitlab"
				  end,
})

EOF

"set updatetime=500

" Statusline
function! LspStatus() abort
	if luaeval('#vim.lsp.buf_get_clients() > 0')
		return luaeval("require('lsp-status').status()")
	endif

	return ''
endfunction

command Format lua vim.lsp.buf.formatting()<CR>


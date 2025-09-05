lua << EOF
local gitlab_config = {
			statusline = { enabled = false },
		}

-- add gitlab wiki lsp in separte call because nvm_lspconfig doesn't know about it yet
require('gitlab').setup(gitlab_config)
EOF


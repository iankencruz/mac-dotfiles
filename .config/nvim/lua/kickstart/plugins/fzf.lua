return {
	"ibhagwan/fzf-lua",
	-- Optional dependencies for better visual experience
	dependencies = { "nvim-tree/nvim-web-devicons" },

	-- Global setup options for fzf-lua
	opts = {
		fzf_opts = { ["--layout"] = "reverse" },

		keymap = {
			fzf = {
				["ctrl-q"] = "select-all+accept",
			},
		},

		previewers = {
			builtin = {
				-- fzf-lua is very fast, but it really struggled to preview a couple files
				-- in a repo. Those files were very big JavaScript files (1MB, minified, all on a single line).
				-- It turns out it was Treesitter having trouble parsing the files.
				-- With this change, the previewer will not add syntax highlighting to files larger than 100KB
				-- (Yes, I know you shouldn't have 100KB minified files in source control.)
				syntax_limit_b = 1024 * 100, -- 100KB
			},
		},

		-- Optional: Configure the default window appearance
		winopts = {
			-- split = "belowright new",-- open in a split instead?
			-- "belowright new"  : split below
			-- "aboveleft new"   : split above
			-- "belowright vnew" : split right
			-- "aboveleft vnew   : split left
			-- Only valid when using a float window
			-- (i.e. when 'split' is not defined, default)
			height = 0.85, -- window height
			width = 0.80, -- window width
			row = 0.35, -- window row position (0=top, 1=bottom)
			col = 0.50, -- window col position (0=left, 1=right)
			-- border argument passthrough to nvim_open_win()
			border = "rounded",
			-- Backdrop opacity, 0 is fully opaque, 100 is fully transparent (i.e. disabled)
			backdrop = 60,
			-- title         = "Title",
			-- title_pos     = "center",        -- 'left', 'center' or 'right'
			-- title_flags   = false,           -- uncomment to disable title flags
			fullscreen = false, -- start fullscreen?

			-- enable treesitter highlighting for the main fzf window will only have
			-- effect where grep like results are present, i.e. "file:line:col:text"
			-- due to highlight color collisions will also override `fzf_colors`
			-- set `fzf_colors=false` or `fzf_colors.hl=...` to override
			treesitter = {
				enabled = true,
				fzf_colors = { ["hl"] = "-1:reverse", ["hl+"] = "-1:reverse" },
			},
			preview = {
				default = "bat", -- override the default previewer?
				-- default uses the 'builtin' previewer
				border = "rounded", -- preview border: accepts both `nvim_open_win`
				-- and fzf values (e.g. "border-top", "none")
				-- native fzf previewers (bat/cat/git/etc)
				-- can also be set to `fun(winopts, metadata)`
				wrap = false, -- preview line wrap (fzf's 'wrap|nowrap')
				hidden = false, -- start preview hidden
				vertical = "up:65%", -- up|down:size
				horizontal = "right:60%", -- right|left:size
				layout = "flex", -- horizontal|vertical|flex
				flip_columns = 100, -- #cols to switch to horizontal on flex
				-- Only used with the builtin previewer:
				title = true, -- preview border title (file/buf)?
				title_pos = "center", -- left|center|right, title alignment
				scrollbar = "float", -- `false` or string:'float|border'
				-- float:  in-window floating border
				-- border: in-border "block" marker
				scrolloff = -1, -- float scrollbar offset from right
				-- applies only when scrollbar = 'float'
				delay = 20, -- delay(ms) displaying the preview
				-- prevents lag on fast scrolling
				winopts = { -- builtin previewer window options
					number = true,
					relativenumber = false,
					cursorline = true,
					cursorlineopt = "both",
					cursorcolumn = false,
					signcolumn = "no",
					list = false,
					foldenable = false,
					foldmethod = "manual",
				},
			},
			on_create = function()
				-- called once upon creation of the fzf main window
				-- can be used to add custom fzf-lua mappings, e.g:
				--   vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
			end,
			-- called once _after_ the fzf interface is closed
			-- on_close = function() ... end
		},

		-- Optional: Configure how oldfiles (recent files) works
		oldfiles = {
			-- In Telescope, when I used <leader>fr, it would load old buffers.
			-- fzf lua does the same, but by default buffers visited in the current
			-- session are not included. I use <leader>fr all the time to switch
			-- back to buffers I was just in. If you missed this from Telescope,
			-- give it a try.
			include_current_session = true,
		},
	},

	-- Keymaps for Telescope replacement
	keys = {
		-- File Navigation
		{
			"<leader>fe",
			function()
				require("fzf-lua").files()
			end,
			desc = "FZF: Files (Project)",
		},
		{
			"<leader>fr",
			function()
				require("fzf-lua").oldfiles()
			end,
			desc = "FZF: Recent Files",
		},
		{
			"<leader>fb",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "FZF: Buffers",
		},
		{
			"<leader>ft",
			function()
				require("fzf-lua").tabs()
			end,
			desc = "FZF: Tabs",
		},

		--- 💡 LSP Pickers 💡
		-- Renamed: Document Symbols
		{
			"<leader>q",
			function()
				require("fzf-lua").diagnostics_document()
			end,
			desc = "FZF: [Q] Quick Document Diagnostics",
		},
		{
			"<leader>fds",
			function()
				require("fzf-lua").lsp_document_symbols()
			end,
			desc = "FZF: Document Symbols (LSP)",
		},
		{
			"<leader>fdw",
			function()
				require("fzf-lua").lsp_workspace_symbols()
			end,
			desc = "FZF: Document Symbols (LSP)",
		},
		-- New: LSP References (like <leader>gr in Telescope)
		{
			"<leader>ls",
			function()
				require("fzf-lua").lsp_references()
			end,
			desc = "FZF: LSP References",
		},

		--- 🛠️ Quickfix/Location List Pickers 🛠️
		-- New: Location List (loclist)
		{
			"<leader>fl",
			function()
				require("fzf-lua").loclist()
			end,
			desc = "FZF: Location List",
		},

		-- Text Search (Grep)
		{
			"<leader>fg",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "FZF: Live Grep",
		},
		{
			"<leader>fp",
			function()
				require("fzf-lua").grep_project()
			end,
			desc = "FZF: Grep Project",
		},

		-- Git Integration
		{
			"<leader>lf",
			function()
				require("fzf-lua").git_files()
			end,
			desc = "FZF: Git Files",
		},
		{
			"<leader>lc",
			function()
				require("fzf-lua").git_commits()
			end,
			desc = "FZF: Git Commits (Project)",
		},
		{
			"<leader>ls",
			function()
				require("fzf-lua").git_status()
			end,
			desc = "FZF: Git Status",
		},

		-- Miscellaneous
		{
			"<leader>fh",
			function()
				require("fzf-lua").helptags()
			end,
			desc = "FZF: Help Tags",
		},

		{
			"<leader>z",
			function()
				require("fzf-lua").resume()
			end,
			desc = "FZF: Resume last picker",
		},
	},
}

-- For `plugins/markview.lua` users.
return {
	{
		"OXY2DEV/markview.nvim",
		lazy = false,

		-- For blink.cmp's completion
		-- source
		dependencies = {
			"saghen/blink.cmp",
		},
		keys = {
			{ "<Leader>mt", "<cmd>Markview Toggle<CR>", desc = "Toggle Markview" },
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && bun install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		keys = {
			{ "<Leader>mp", "<cmd>MarkdownPreview<CR>", desc = "Preview Markdown" },
		},
		ft = { "markdown" },
	},
}

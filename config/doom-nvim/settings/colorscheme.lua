function config.kanagawa()
	local kanagawa = require("kanagawa")

	kanagawa.setup({
		undercurl = true,
		commentStyle = "italic",
		functionStyle = "bold,italic",
		keywordStyle = "italic",
		statementStyle = "bold",
		typeStyle = "NONE",
		variablebuiltinStyle = "italic",
		specialReturn = true,
		specialException = true,
		transparent = false,
		dimInactive = true,
		colors = {},
		overrides = {},
	})
end

function config.kanagawa()
	local catppuccin = require("catppuccin")

	catppuccin.setup({
		transparent_background = false,
		term_colors = true,
		styles = {
			comments = "italic",
			functions = "italic,bold",
			keywords = "italic",
			strings = "NONE",
			variables = "NONE",
		},
		integrations = {
			treesitter = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = "italic",
					hints = "italic",
					warnings = "italic",
					information = "italic",
				},
				underlines = {
					errors = "underline",
					hints = "underline",
					warnings = "underline",
					information = "underline",
				},
			},
			lsp_trouble = true,
			lsp_saga = true,
			gitgutter = false,
			gitsigns = true,
			telescope = true,
			nvimtree = { enabled = true, show_root = true },
			which_key = true,
			indent_blankline = { enabled = true, colored_indent_levels = false },
			dashboard = true,
			neogit = false,
			vim_sneak = false,
			fern = false,
			barbar = false,
			bufferline = true,
			markdown = true,
			lightspeed = false,
			ts_rainbow = true,
			hop = true,
		},
	})
end

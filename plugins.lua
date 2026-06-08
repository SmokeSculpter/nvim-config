-- Plugins

vim.pack.add({
	"https://www.github.com/lewis6991/gitsigns.nvim",
	"https://www.github.com/echasnovski/mini.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	"https://www.github.com/nvim-tree/nvim-tree.lua",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	{
		src = "https://github.com/catppuccin/nvim",
		name = "catppuccin",
	},
	{
		src = "https://github.com/marko-cerovac/material.nvim",
		name = "material",
	},
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/mrcjkb/rustaceanvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/akinsho/bufferline.nvim",
	"https://github.com/tiagovla/scope.nvim",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-flutter/flutter-tools.nvim",
  "https://github.com/scottmckendry/cyberdream.nvim",
  "https://github.com/rebelot/kanagawa.nvim",
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/nvimdev/dashboard-nvim",
})

-- Colorscheme

require("cyberdream").setup({})
vim.cmd.colorscheme("cyberdream")

-- Dashboard

require("dashboard").setup({
	theme = "hyper",
	config = {
shortcut = {},
		project = { enable = false },
		mru = { enable = true, limit = 8, icon = " ", label = "Recent Files" },
		footer = {},
	},
})

-- Lualine

require("lualine").setup({
	options = {
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- Treesitter

local function setup_treesitter()
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})

	local ensure_installed = {
		"vim", "vimdoc", "rust", "c", "cpp", "go", "html", "css",
		"javascript", "json", "lua", "markdown", "python", "typescript",
		"vue", "svelte", "bash", "dart",
	}

	local config = require("nvim-treesitter.config")
	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			local lang = vim.treesitter.language.get_lang(args.match)
			if lang and vim.list_contains(treesitter.get_installed(), lang) then
				vim.defer_fn(function()
					if vim.api.nvim_buf_is_valid(args.buf) then
						vim.treesitter.start(args.buf)
					end
				end, 50)
			end
		end,
	})
end

setup_treesitter()

-- NvimTree

require("nvim-tree").setup({
	view = { width = 35 },
	filters = { dotfiles = false },
	renderer = { group_empty = true },
	on_attach = function(bufnr)
		local api = require("nvim-tree.api")
		local opts = function(desc)
			return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
		end
		api.config.mappings.default_on_attach(bufnr)
		vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
		vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
	end,
})

vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#2a2a2a", bg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

-- FZF

require("fzf-lua").setup({})

-- Mini

require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})
require("mini.icons").setup({})
MiniIcons.mock_nvim_web_devicons()

-- Gitsigns

require("gitsigns").setup({
	signs = {
		add          = { text = "\u{2590}" },
		change       = { text = "\u{2590}" },
		delete       = { text = "\u{2590}" },
		topdelete    = { text = "\u{25e6}" },
		changedelete = { text = "\u{25cf}" },
		untracked    = { text = "\u{25cb}" },
	},
	signcolumn = true,
	current_line_blame = false,
})

-- Mason

require("mason").setup({})

-- Bufferline + Scope
-- scope must be set up first so vim.t.bufs is populated before bufferline renders

require("scope").setup({})

require("bufferline").setup({
	options = {
		mode = "buffers",
		diagnostics = "nvim_lsp",
		show_buffer_close_icons = false,
		show_close_icon = false,
		separator_style = "slant",
		custom_filter = function(buf)
			local bufs = vim.t.bufs
			if not bufs then return true end
			return vim.tbl_contains(bufs, buf)
		end,
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				highlight = "Directory",
				separator = true,
			},
		},
	},
})

-- Render Markdown

require("render-markdown").setup({
  enabled = false,
})

-- nvim-ts-autotag

require("nvim-ts-autotag").setup()

-- LSP, Linting, Formatting & Completion

local diagnostic_signs = {
	Error = " ",
	Warn  = " ",
	Hint  = "",
	Info  = "",
}

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 4,
		severity = { min = vim.diagnostic.severity.WARN },
		right_align = true, -- fixed: was "right_aling"
	},
	signs = {
		severity = { min = vim.diagnostic.severity.WARN },
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN]  = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO]  = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT]  = diagnostic_signs.Hint,
		},
	},
	underline = { severity = { min = vim.diagnostic.severity.WARN } },
	update_in_insert = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

-- LSP on-attach: keymaps and per-client setup

local function setup_lsp_keymaps(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "<leader>gd", function()
		require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	end, opts)
	vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "<leader>gS", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition()
	end, opts)

	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	vim.keymap.set("n", "<leader>D", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, opts)
	vim.keymap.set("n", "<leader>d", function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, opts)
	vim.keymap.set("n", "<leader>nd", function()
		vim.diagnostic.jump({ count = 1 })
	end, opts)
	vim.keymap.set("n", "<leader>pd", function()
		vim.diagnostic.jump({ count = -1 })
	end, opts)

	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

	vim.keymap.set("n", "<leader>fd", function()
		require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	end, opts)
	vim.keymap.set("n", "<leader>fr", function() require("fzf-lua").lsp_references() end, opts)
	vim.keymap.set("n", "<leader>ft", function() require("fzf-lua").lsp_typedefs() end, opts)
	vim.keymap.set("n", "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, opts)
	vim.keymap.set("n", "<leader>fw", function() require("fzf-lua").lsp_workspace_symbols() end, opts)
	vim.keymap.set("n", "<leader>fi", function() require("fzf-lua").lsp_implementations() end, opts)

	if client:supports_method("textDocument/codeAction", bufnr) then
		vim.keymap.set("n", "<leader>oi", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
				bufnr = bufnr,
			})
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50)
		end, opts)
	end
end

local augroup = vim.api.nvim_create_augroup("PluginConfig", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then return end
		setup_lsp_keymaps(client, ev.buf)
	end,
})

-- Blink completion

require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "hide" },
		["<CR>"]      = { "accept", "fallback" },
		["<C-j>"]     = { "select_next", "fallback" },
		["<C-k>"]     = { "select_prev", "fallback" },
		["<Tab>"]     = { "select_next", "snippet_forward", "fallback" },
		["<S-Tab>"]   = { "select_prev", "snippet_backward", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = { menu = { auto_show = true } },
	sources = { default = { "lsp", "path", "buffer", "snippets" } },
	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = { download = true },
	},
})

-- LSP server configs

vim.lsp.config["*"] = {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
}

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
})
vim.lsp.config("pyright", {})
vim.lsp.config("bashls", {})
vim.lsp.config("ts_ls", {
	settings = {
		typescript = {
			preferences = { strictNullChecks = true },
		},
		diagnostics = { ignoredCodes = {} },
	},
	handlers = {
		["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
			if result.diagnostics then
				for _, diag in ipairs(result.diagnostics) do
					if diag.code == 6133 then
						diag.severity = vim.diagnostic.severity.WARN
					end
				end
			end
			-- fixed: use the current handler API
			vim.lsp.handlers["textDocument/publishDiagnostics"](_, result, ctx, config)
		end,
	},
})
vim.lsp.config("tailwindcss", {})
vim.lsp.config("gopls", {})
vim.lsp.config("clangd", {})

-- EFM (formatting + linting)

do
	local luacheck   = require("efmls-configs.linters.luacheck")
	local stylua     = require("efmls-configs.formatters.stylua")
	local flake8     = require("efmls-configs.linters.flake8")
	local black      = require("efmls-configs.formatters.black")
	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local eslint_d   = require("efmls-configs.linters.eslint_d")
	local fixjson    = require("efmls-configs.formatters.fixjson")
	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt      = require("efmls-configs.formatters.shfmt")
	local cpplint    = require("efmls-configs.linters.cpplint")
	local clangfmt   = require("efmls-configs.formatters.clang_format")
	local go_revive  = require("efmls-configs.linters.go_revive")
	local gofumpt    = require("efmls-configs.formatters.gofumpt")

	vim.lsp.config("efm", {
		filetypes = {
			"c", "cpp", "css", "go", "html", "javascript", "javascriptreact",
			"json", "jsonc", "lua", "markdown", "python", "sh",
			"typescript", "typescriptreact", "vue", "svelte",
		},
		init_options = { documentFormatting = true },
		settings = {
			languages = {
				c              = { clangfmt, cpplint },
				cpp            = { clangfmt, cpplint },
				css            = { prettier_d },
				go             = { gofumpt, go_revive },
				html           = { prettier_d },
				javascript     = { eslint_d, prettier_d },
				javascriptreact= { eslint_d, prettier_d },
				json           = { eslint_d, fixjson },
				jsonc          = { eslint_d, fixjson },
				lua            = { luacheck, stylua },
				markdown       = { prettier_d },
				python         = { flake8, black },
				sh             = { shellcheck, shfmt },
				typescript     = { eslint_d, prettier_d },
				typescriptreact= { eslint_d, prettier_d },
				vue            = { eslint_d, prettier_d },
				svelte         = { eslint_d, prettier_d },
			},
		},
	})
end

vim.lsp.enable({
	"lua_ls",
  "pyright",
  "bashls",
  "ts_ls",
	"gopls",
  "clangd",
  "efm",
  "tailwindcss",
  "marksman"
})

-- Rustacean

vim.g.rustaceanvim = {
	server = {
		capabilities = require("blink.cmp").get_lsp_capabilities(),
		default_settings = {
			["rust-analyzer"] = {
				checkOnSave = true,
				check = { command = "clippy" },
				diagnostics = { enable = true },
				inlayHints = { enable = true },
			},
		},
	},
}

-- Flutter tools

require("flutter-tools").setup({
	flutter_path = vim.fn.expand("$HOME/flutter/bin/flutter"),
	lsp = {
		capabilities = require("blink.cmp").get_lsp_capabilities(),
		on_attach = function(client, bufnr)
			setup_lsp_keymaps(client, bufnr)
		end,
	},
	widget_guides = { enabled = true },
	debugger = { enabled = false },
})

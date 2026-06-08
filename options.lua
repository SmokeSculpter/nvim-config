vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.scrolloff = 20
vim.opt.sidescrolloff = 10
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25-blinkwait700-blinkon400-blinkoff250,r-cr:hor20,o:hor50"

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.showmatch = true
vim.opt.cmdheight = 1
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.showmode = false
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.concealcursor = ""
vim.opt.synmaxcol = 300
vim.opt.signcolumn = "yes:1"

local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = undodir
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 50
vim.opt.autoread = true
vim.opt.autowrite = false

vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.selection = "inclusive"
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.modifiable = true
vim.opt.encoding = "utf-8"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.diffopt:append("linematch:60")
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- Auto Commands

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	callback = function(args)
		local file = vim.api.nvim_buf_get_name(args.buf)
		if file == "" then return end
		local dir = vim.fn.fnamemodify(file, ":h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = {
		"*.lua", "*.py", "*.go", "*.js", "*.jsx", "*.ts", "*.tsx",
		"*.json", "*.css", "*.scss", "*.html", "*.sh", "*.bash", "*.zsh",
		"*.c", "*.cpp", "*.h", "*.hpp",
	},
	callback = function(args)
		if vim.bo[args.buf].buftype ~= "" then return end
		if not vim.bo[args.buf].modifiable then return end
		if vim.api.nvim_buf_get_name(args.buf) == "" then return end

		local has_efm = false
		for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			if c.name == "efm" then
				has_efm = true
				break
			end
		end
		if not has_efm then return end

		pcall(vim.lsp.buf.format, {
			bufnr = args.buf,
			timeout_ms = 2000,
			filter = function(c) return c.name == "efm" end,
		})
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then return end
		local last_pos = vim.api.nvim_buf_get_mark(0, '"')
		local last_line = vim.api.nvim_buf_line_count(0)
		local row = last_pos[1]
		if row < 1 or row > last_line then return end
		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true

        -- only set the gd keymap for markdown, not text/gitcommit
        if vim.bo.filetype == "markdown" then
            vim.keymap.set("n", "gd", function()
                local line = vim.api.nvim_get_current_line()
                local col = vim.api.nvim_win_get_cursor(0)[2] + 1
                for text, path in line:gmatch("%[(.-)%]%((.-)%)") do
                    local s, e = line:find("%[" .. vim.pesc(text) .. "%]%(" .. vim.pesc(path) .. "%)")
                    if s and col >= s and col <= e then
                        vim.cmd("edit " .. vim.fn.fnameescape(path))
                        return
                    end
                end
            end, { buffer = true, desc = "Follow markdown link" })
        end
    end,
})

if vim.g.neovide then
  vim.g.neovide_opacity = 0.75
end

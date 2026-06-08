vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Movement

vim.keymap.set("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })

vim.keymap.set("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Editing

vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })
vim.keymap.set("i", "<C-S-v>", "<C-r>+", { desc = "Paste from clipboard in insert mode" })

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Saving

vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("v", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- Buffers

vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", function()
	require("mini.bufremove").delete()
end, { desc = "Delete buffer" })

-- Windows

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Tabs

vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { desc = "Close all other tabs" })
vim.keymap.set("n", "<S-C-l>", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<S-C-h>", ":tabprevious<CR>", { desc = "Previous tab" })

-- Terminal

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>tr", function()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buftype == "terminal" and vim.bo[buf].channel ~= 0 then
			vim.api.nvim_chan_send(vim.bo[buf].channel, "exec $SHELL\n")
		end
	end
end, { desc = "Reload shell in all terminal buffers" })

-- Misc

vim.keymap.set("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- NvimTree

vim.keymap.set("n", "<leader>e", function()
	require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })

-- FZF

vim.keymap.set("n", "<leader>ff", function() require("fzf-lua").files() end, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fg", function() require("fzf-lua").live_grep() end, { desc = "FZF Live Grep" })
vim.keymap.set("n", "<leader>fb", function() require("fzf-lua").buffers() end, { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>fh", function() require("fzf-lua").help_tags() end, { desc = "FZF Help Tags" })
vim.keymap.set("n", "<leader>fx", function() require("fzf-lua").diagnostics_document() end, { desc = "FZF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", function() require("fzf-lua").diagnostics_workspace() end, { desc = "FZF Diagnostics Workspace" })

-- LSP (set up on attach, not globally)

vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- Git (gitsigns)

vim.keymap.set("n", "]h", function() require("gitsigns").nav_hunk("next") end, { desc = "Next git hunk" })
vim.keymap.set("n", "[h", function() require("gitsigns").nav_hunk("prev") end, { desc = "Previous git hunk" })
vim.keymap.set("n", "<leader>hs", function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hr", function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>hp", function() require("gitsigns").preview_hunk() end, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>hb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame line" })
vim.keymap.set("n", "<leader>hB", function() require("gitsigns").toggle_current_line_blame() end, { desc = "Toggle inline blame" })
vim.keymap.set("n", "<leader>hd", function() require("gitsigns").diffthis() end, { desc = "Diff this" })

-- Markdown

vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle markdown render" })

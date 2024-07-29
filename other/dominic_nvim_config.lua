local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key so it can be used immediately.
vim.g.mapleader = " "

-- Plugins
require("lazy").setup({
	-- Also requires ripgrep and fd.
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.5',
		dependencies = {
			'nvim-lua/plenary.nvim',
			"debugloop/telescope-undo.nvim",
		}
	},
	{ "ellisonleao/gruvbox.nvim",         priority = 1000,    config = true },
	{ "nvim-treesitter/nvim-treesitter",  build = ":TSUpdate" },
	{ "tpope/vim-fugitive" },

	-- LSP related stuff
	{ 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
	{ 'williamboman/mason.nvim' },
	{ 'williamboman/mason-lspconfig.nvim' },
	{ 'neovim/nvim-lspconfig' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'L3MON4D3/LuaSnip' },

	-- Scala
	{ 'scalameta/nvim-metals' },
})

-- Telescope Config
-- TODO: Revisit for additional pickers.
local telescope = require('telescope.builtin')
require("telescope").load_extension("undo")

-- Theme Config
vim.cmd("colorscheme gruvbox")

-- Treesitter Config
require("nvim-treesitter.configs").setup({
	ensure_installed = { "vim", "vimdoc", "query", "c", "lua", "go" },
	sync_install = false,
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
})

-- Cmp Config
local cmp = require('cmp')
cmp.setup({
	completion = {
		completeopt = 'menu,menuone,noinsert'
	},
	mapping = cmp.mapping.preset.insert({
		['<C-k>'] = cmp.mapping.confirm({ select = true }),
	}),
})

-- LSP Config
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
	handlers = {
		lsp_zero.default_setup,
	}
})

-- Scala
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "scala", "sbt", "java" },
	callback = function()
		require("metals").initialize_or_attach({})
	end,
	group = nvim_metals_group,
})

-- Custom Keymaps
local function remap(mode, key, command)
	vim.keymap.set(mode, key, command, { silent = true })
end

-- Center cursor after scroll/search
remap("n", "<C-u>", "<C-u>zz")
remap("n", "<C-d>", "<C-d>zz")
remap("n", "n", "nzz")
remap("n", "N", "Nzz")

remap("n", "<leader>w", "<cmd>w<cr>")
remap("n", "<leader>W", "<cmd>wa<cr>")
remap("n", "<leader>q", "<cmd>q<cr>")
remap("n", "<leader>Q", "<cmd>qa<cr>")
remap("n", "<leader>k", "<cmd>bp|bd #<cr>")

-- Move selected content up/down
remap("v", "J", ":m '>+1<cr>gv=gv")
remap("v", "K", ":m '<-2<cr>gv=gv")

remap("n", "<leader>pv", vim.cmd.Ex)

-- Repeat command/macro on selected lines.
remap("v", ".", ":norm .<CR>")
remap("v", "@", ":norm @q<CR>")

-- Interact with system clipboard
remap("n", "<leader>xp", ":call setreg('+', getreg('@'))<CR>")

-- Fix List
-- TODO

-- Telescope
remap('n', '<C-f>', telescope.find_files)
remap('n', '<C-b>', telescope.buffers)
remap('n', '<C-p>', telescope.git_files)
remap('n', '<C-s>', telescope.live_grep)
remap("n", "<leader>u", "<cmd>Telescope undo<cr>")

-- Fugitive
-- TODO: Push/pull, conflict merging
remap("n", "<leader>gs", vim.cmd.Git)
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	callback = function()
		if vim.bo.ft ~= "fugitive" then
			return
		end

		local bufnr = vim.api.nvim_get_current_buf()
		local opts = { buffer = bufnr, remap = false }
		vim.keymap.set("n", "<leader>p", function()
			vim.cmd.Git('push')
		end, opts)

		-- rebase always
		vim.keymap.set("n", "<leader>P", function()
			vim.cmd.Git('pull')
		end, opts)
	end,
})

-- LSP related stuff
remap("n", "<C-j>", vim.diagnostic.goto_next)
remap("n", "<C-k>", vim.diagnostic.goto_prev)
remap("n", "<leader>f", vim.lsp.buf.format)
remap("i", "<C-h>", vim.lsp.buf.signature_help)
remap("n", "<leader>la", vim.lsp.buf.code_action)
remap("n", "<leader>ls", vim.lsp.buf.document_symbol)

-- Custom Settings
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.ignorecase = true
vim.opt.smartcase = true
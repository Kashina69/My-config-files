-- ============================================
-- Bootstrap lazy.nvim Plugin Manager
-- ============================================
-- Set the path for lazy.nvim installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is already installed
if not vim.loop.fs_stat(lazypath) then
  -- If not installed, clone the repository
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- Prepend lazy.nvim to runtime path for Neovim to recognize it
vim.opt.rtp:prepend(lazypath)

-- ============================================
-- Install Essential Plugins
-- ============================================
require("lazy").setup({
  -- Core LSP and autocompletion
  "neovim/nvim-lspconfig",    -- Enables LSP (Language Server Protocol) for coding assistance
  "hrsh7th/nvim-cmp",         -- Main plugin for autocompletion
  "hrsh7th/cmp-nvim-lsp",     -- Connects LSP with nvim-cmp for suggestions
  "L3MON4D3/LuaSnip",         -- Snippet engine for coding shortcuts
  "saadparwaiz1/cmp_luasnip", -- Integrates LuaSnip with nvim-cmp for autocompletion

  -- Language-specific support
  "rust-lang/rust.vim", -- Rust-specific features
  "fatih/vim-go",       -- Go-specific features

  -- Code linting and formatting
  "jose-elias-alvarez/null-ls.nvim", -- Integrates linters and formatters with LSP

  -- Git integration
  "tpope/vim-fugitive",      -- Simplifies Git commands within Neovim
  "lewis6991/gitsigns.nvim", -- Shows git changes in the sign column

  -- File explorer for managing files and directories
  "nvim-tree/nvim-tree.lua",
  "kyazdani42/nvim-web-devicons", -- Adds icons to the file explorer and more

  -- Themes and UI enhancements
  "ellisonleao/gruvbox.nvim",  -- Gruvbox theme for better visuals
  "folke/tokyonight.nvim",     -- Tokyonight theme for a sleek appearance

  "nvim-lualine/lualine.nvim", -- Customizable status line at the bottom
  "akinsho/bufferline.nvim",   -- Displays open buffers/tabs

  -- Debugging tools
  "mfussenegger/nvim-dap", -- Interface for debugging
})

-- ============================================
-- Configure LSP for Various Languages
-- ============================================
local lspconfig = require('lspconfig')

-- Example LSP configurations for different languages
lspconfig.ts_ls.setup {}         -- LSP for JavaScript/TypeScript
lspconfig.gopls.setup {}         -- LSP for Go
lspconfig.pyright.setup {}       -- LSP for Python
lspconfig.rust_analyzer.setup {} -- LSP for Rust
lspconfig.clangd.setup {}        -- LSP for C/C++
lspconfig.html.setup {}          -- LSP for HTML
lspconfig.cssls.setup {}         -- LSP for CSS

-- Enable built-in syntax highlighting
vim.cmd('syntax on')

-- ============================================
-- Configure nvim-cmp for Autocompletion
-- ============================================
local cmp = require('cmp')

-- Setup nvim-cmp for autocompletion
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- Expand snippets using LuaSnip
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),           -- Scroll documentation up
    ['<C-f>'] = cmp.mapping.scroll_docs(4),            -- Scroll documentation down
    ['<C-Space>'] = cmp.mapping.complete(),            -- Trigger completion menu
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selected completion
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- LSP suggestions
    { name = 'luasnip' },  -- Snippet suggestions
  }, {
    { name = 'buffer' },   -- Suggestions from open buffers
  })
}

-- ============================================
-- File Explorer Configuration
-- ============================================
require('nvim-tree').setup {
  view = {
    side = 'left', -- File explorer appears on the left side
    width = 30,    -- Set the width of the file explorer window
  },
  filters = {
    dotfiles = true, -- Show hidden files in the explorer
  },
}

-- ============================================
-- Git Integration Configuration
-- ============================================
require('gitsigns').setup() -- Setup gitsigns to show added/removed/modified lines

-- ============================================
-- Status Line and Bufferline Configuration
-- ============================================
require('lualine').setup {
  options = {
    theme = 'tokyonight', -- Set the theme for the status line (change to 'gruvbox' if you prefer)
  },
}

require("bufferline").setup {} -- Setup bufferline for managing open tabs/buffers

-- ============================================
-- Linting and Formatting Configuration
-- ============================================
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,  -- JavaScript/TypeScript formatting with Prettier
    null_ls.builtins.formatting.goimports, -- Go formatting with Goimports
    null_ls.builtins.formatting.rustfmt,   -- Rust formatting with Rustfmt
    null_ls.builtins.diagnostics.eslint,   -- JavaScript/TypeScript linting with ESLint
  },
})

-- ============================================
-- Theme Configuration
-- ============================================
vim.cmd [[colorscheme tokyonight]] -- Set the colorscheme (change to 'gruvbox' if preferred)

-- ============================================
-- Key Mappings for Ease of Use
-- ============================================

-- Key mapping to toggle the file explorer with Ctrl + B
vim.api.nvim_set_keymap('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true })

-- Key mapping to open a terminal with Ctrl + T
vim.api.nvim_set_keymap('n', '<C-t>', ':terminal<CR>', { noremap = true })

-- Key mapping to open file finder using Telescope with <leader> + f
vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope find_files<CR>', { noremap = true })

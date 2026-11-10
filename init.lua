-- ~/.config/nvim/init.lua
-- Cross-platform (macOS + Linux) single-file Neovim config

-------------------------------------------------------------------------------
-- CORE OPTIONS
-------------------------------------------------------------------------------
local opt = vim.opt

opt.number         = true          -- line numbers
opt.relativenumber = false         -- absolute line numbers
opt.cursorline     = true          -- highlight current line
opt.signcolumn     = "yes"         -- always show sign column (prevents jitter)
opt.scrolloff      = 8             -- keep 8 lines above/below cursor
opt.wrap           = false         -- no line wrapping

-- Indentation: 4 spaces, no tabs
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.softtabstop    = 4
opt.expandtab      = true
opt.smartindent    = true

-- Search
opt.ignorecase     = true
opt.smartcase      = true          -- case-sensitive if uppercase used
opt.hlsearch       = true
opt.incsearch      = true

-- Files
opt.undofile       = true          -- persistent undo (stored in stdpath("state"))
opt.backup         = false
opt.swapfile       = false

-- Clipboard: works on both macOS (pbcopy) and Linux (xclip/xsel/wl-copy)
opt.clipboard      = "unnamedplus"

-- Splits open naturally
opt.splitbelow     = true
opt.splitright     = true

-- Faster UI updates (also helps with git gutter plugins)
opt.updatetime     = 250

-- Use system shell explicitly to avoid issues with non-POSIX shells (fish, etc.)
opt.shell          = "/bin/sh"

-------------------------------------------------------------------------------
-- FILETYPE OVERRIDES
-------------------------------------------------------------------------------
-- Makefiles need real tabs
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab   = false
    vim.opt_local.tabstop     = 4
    vim.opt_local.shiftwidth  = 4
    vim.opt_local.softtabstop = 0
  end,
})

-- Trim trailing whitespace on save (preserves cursor position)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.sh", "*.md", "*.yaml", "*.yml", "*.json",
              "*.c", "*.cpp", "*.java", "*.php",
              "*.py", "*.js", "*.ts", "*.vim", "*.lua" },
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-------------------------------------------------------------------------------
-- KEYMAPS
-------------------------------------------------------------------------------
vim.g.mapleader = " "

-- Word-wise motion in insert mode (iTerm2 on macOS + most Linux terminals)
vim.keymap.set("i", "<M-f>", "<C-\\><C-o>w", { desc = "Forward one word" })
vim.keymap.set("i", "<M-b>", "<C-\\><C-o>b", { desc = "Back one word" })
vim.keymap.set({ "n", "v" }, "<M-f>", "w",   { desc = "Forward one word" })
vim.keymap.set({ "n", "v" }, "<M-b>", "b",   { desc = "Back one word" })

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Better split navigation (Ctrl+hjkl)
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Diagnostics
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,         { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next,         { desc = "Next diagnostic" })

-------------------------------------------------------------------------------
-- COLORSCHEME SELECTION
-- Change ACTIVE_THEME to any key below to switch your colorscheme.
-------------------------------------------------------------------------------
--
--   ubuntu    → dark purple/orange  (tokyonight-night, purple-tinted bg)
--   fedora    → deep blue           (tokyonight-moon)
--   suse      → green tones         (everforest)
--   mac       → soft gray/blue      (tokyonight-storm)
--   black     → pitch black bg      (vscode dark, #000000 bg)
--   white     → light background    (tokyonight-day)
--   retro     → amber terminal feel (monokai classic)
--   gray      → muted neutral       (gruvbox soft)
--   warm      → warm earthy tones   (gruvbox hard)
--   cold      → icy blue/teal       (tokyonight-moon, deep blue bg)
--   kanagawa  → Japanese ink        (kanagawa)
--   gruvbox   → classic warm dark   (gruvbox default)
--   catppuccin → pastel dark        (catppuccin-mocha)
--   nord      → arctic blue         (nord)
--   onedark   → Atom One Dark       (onedark)
--
-- ↓↓↓ CHANGE THIS LINE TO SWITCH THEME ↓↓↓
local ACTIVE_THEME = "black"
-- ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

local themes = {
  ubuntu     = { plugin = "folke/tokyonight.nvim",    scheme = "tokyonight-night",  setup = function() require("tokyonight").setup({ style = "night", on_colors = function(c) c.bg = "#1a0030"; c.bg_dark = "#12001f" end }) end },
  fedora     = { plugin = "folke/tokyonight.nvim",    scheme = "tokyonight-moon",   setup = nil },
  suse       = { plugin = "sainnhe/everforest",        scheme = "everforest",        setup = function() vim.g.everforest_background = "medium"; vim.g.everforest_better_performance = 1 end },
  mac        = { plugin = "folke/tokyonight.nvim",    scheme = "tokyonight-storm",  setup = nil },
  black      = { plugin = "Mofiqul/vscode.nvim",      scheme = "vscode",            setup = function() require("vscode").setup({ style = "dark", transparent = false, color_overrides = { vscBack = "#000000" } }) end },
  white      = { plugin = "folke/tokyonight.nvim",    scheme = "tokyonight-day",    setup = nil },
  retro      = { plugin = "tanvirtin/monokai.nvim",   scheme = "monokai_pro",       setup = nil },
  gray       = { plugin = "ellisonleao/gruvbox.nvim", scheme = "gruvbox",           setup = function() require("gruvbox").setup({ contrast = "soft" }) end },
  warm       = { plugin = "ellisonleao/gruvbox.nvim", scheme = "gruvbox",           setup = function() require("gruvbox").setup({ contrast = "hard" }) end },
  cold       = { plugin = "folke/tokyonight.nvim",    scheme = "tokyonight-moon",   setup = function() require("tokyonight").setup({ style = "moon", on_colors = function(c) c.bg = "#0a0f1e"; c.bg_dark = "#060b16" end }) end },
  kanagawa   = { plugin = "rebelot/kanagawa.nvim",    scheme = "kanagawa",          setup = nil },
  gruvbox    = { plugin = "ellisonleao/gruvbox.nvim", scheme = "gruvbox",           setup = nil },
  catppuccin = { plugin = "catppuccin/nvim",          scheme = "catppuccin-mocha",  setup = nil },
  nord       = { plugin = "shaunsingh/nord.nvim",     scheme = "nord",              setup = nil },
  onedark    = { plugin = "navarasu/onedark.nvim",    scheme = "onedark",           setup = nil },
}

local selected = assert(themes[ACTIVE_THEME], "Unknown ACTIVE_THEME: " .. ACTIVE_THEME)

-------------------------------------------------------------------------------
-- PLUGIN MANAGER (lazy.nvim)
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- Find git in common locations (nvim may not inherit full PATH on some systems)
  local git = vim.fn.exepath("git")
  if git == "" then
    for _, candidate in ipairs({ "/usr/bin/git", "/usr/local/bin/git", "/opt/homebrew/bin/git" }) do
      if vim.loop.fs_stat(candidate) then git = candidate; break end
    end
  end
  if git == "" then
    vim.notify("lazy.nvim: git not found — plugins will not be installed.\nInstall git and restart nvim.", vim.log.levels.ERROR)
  else
    vim.fn.system({
      git, "clone", "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", lazypath,
    })
  end
end
if not vim.loop.fs_stat(lazypath) then
  vim.notify("lazy.nvim not found at " .. lazypath .. "\nPlugins unavailable.", vim.log.levels.ERROR)
  return
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Linting: fast diagnostics for Python (flake8) and Bash (shellcheck)
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      local linters = {}

      if vim.fn.executable("flake8") == 1 then
        linters.python = { "flake8" }
        lint.linters.flake8.args = vim.list_extend(
          { "--max-line-length=128" },
          lint.linters.flake8.args
        )
      else
        vim.notify("nvim-lint: flake8 not found, Python linting disabled", vim.log.levels.WARN)
      end

      if vim.fn.executable("shellcheck") == 1 then
        linters.sh   = { "shellcheck" }
        linters.bash = { "shellcheck" }
      else
        vim.notify("nvim-lint: shellcheck not found, shell linting disabled", vim.log.levels.WARN)
      end

      lint.linters_by_ft = linters

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function() lint.try_lint() end,
      })
    end,
  },

  -- Active colorscheme (controlled by ACTIVE_THEME above)
  {
    selected.plugin,
    priority = 1000,
    config = function()
      if selected.setup then selected.setup() end
      vim.cmd.colorscheme(selected.scheme)
    end,
  },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>t", "<cmd>NvimTreeToggle<CR>",   desc = "File tree toggle" },
      { "<leader>f", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal current file in tree" },
    },
    config = function()
      require("nvim-tree").setup({
        renderer = {
          icons = {
            show = {
              file         = false,
              folder       = false,
              folder_arrow = false,
              git          = false,
            },
          },
          indent_markers = { enable = true },
        },
        -- Use ▶ / ▼ for open/closed folders instead of nerd font glyphs
        -- (folder icons are off, but arrows still show via indent_markers)
      })
    end,
  },

  -- Fuzzy finder (requires: brew install ripgrep / apt install ripgrep)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",  desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",    desc = "Buffers" },
    },
    config = true,
  },

  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    config = true,
  },

  -- Auto-close brackets and quotes
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = true,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme            = "auto",
          section_separators   = { left = "",  right = "" },   -- no arrows
          component_separators = { left = "│", right = "│" },  -- plain divider
          icons_enabled    = false,                             -- no nerd font icons
        },
      })
    end,
  },

}, {
  install = { colorscheme = { "tokyonight", "gruvbox", "habamax" } },
  checker  = { enabled = false },  -- disable automatic update checks
})

-------------------------------------------------------------------------------
-- DIAGNOSTICS
-------------------------------------------------------------------------------
vim.diagnostic.config({
  virtual_text     = true,
  signs            = true,
  underline        = true,
  update_in_insert = false,
})

-------------------------------------------------------------------------------
-- DIFF COLORS
-- Consistent across all themes: red=delete, green=add, blue=change.
-- Shades are tuned per theme family so they fit the background.
-------------------------------------------------------------------------------
local diff_colors = {
  -- dark themes (purple/blue bg)
  ["tokyonight-night"]  = { add = "#1e4a2e", del = "#4a1a1a", chg = "#0f2d4a", txt_add = "#7eca8a", txt_del = "#e06c75", txt_chg = "#5aafde" },
  ["tokyonight-moon"]   = { add = "#1a3d2b", del = "#3d1a1a", chg = "#0d2640", txt_add = "#73c991", txt_del = "#db6a73", txt_chg = "#4fa8d5" },
  ["tokyonight-storm"]  = { add = "#1c4230", del = "#421c1c", chg = "#102840", txt_add = "#77cc8e", txt_del = "#df6b74", txt_chg = "#52aad8" },
  -- light theme
  ["tokyonight-day"]    = { add = "#d4edda", del = "#f8d7da", chg = "#cce5ff", txt_add = "#155724", txt_del = "#721c24", txt_chg = "#004085" },
  -- green theme
  ["everforest"]        = { add = "#1e3a22", del = "#3a1e1e", chg = "#1a2e3a", txt_add = "#83c092", txt_del = "#e67e80", txt_chg = "#7fbbb3" },
  -- pitch black
  ["vscode"]            = { add = "#0a2a0a", del = "#2a0a0a", chg = "#0a0a2a", txt_add = "#4ec94e", txt_del = "#f44747", txt_chg = "#569cd6" },
  -- amber/retro
  ["monokai_pro"]       = { add = "#1e3a1e", del = "#3a1a1a", chg = "#1a2840", txt_add = "#a9dc76", txt_del = "#ff6188", txt_chg = "#78dce8" },
  -- gruvbox variants (warm/earthy)
  ["gruvbox"]           = { add = "#1d2b1d", del = "#2b1a1a", chg = "#1a1f2b", txt_add = "#b8bb26", txt_del = "#fb4934", txt_chg = "#83a598" },
  -- kanagawa
  ["kanagawa"]          = { add = "#1e3122", del = "#3a1a20", chg = "#0f2440", txt_add = "#76946a", txt_del = "#c34043", txt_chg = "#7e9cd8" },
  -- catppuccin mocha
  ["catppuccin-mocha"]  = { add = "#1e3a2a", del = "#3a1e22", chg = "#1a2440", txt_add = "#a6e3a1", txt_del = "#f38ba8", txt_chg = "#89b4fa" },
  -- nord
  ["nord"]              = { add = "#2b3f2b", del = "#3f2b2b", chg = "#2b303f", txt_add = "#a3be8c", txt_del = "#bf616a", txt_chg = "#81a1c1" },
  -- onedark
  ["onedark"]           = { add = "#1e3320", del = "#3a1e1e", chg = "#1a2840", txt_add = "#98c379", txt_del = "#e06c75", txt_chg = "#61afef" },
}

local function apply_diff_colors()
  local scheme = vim.g.colors_name or ""
  local c = diff_colors[scheme]
  if not c then
    -- generic fallback that works on any dark theme
    c = { add = "#1e3a22", del = "#3a1a1a", chg = "#0f2640",
          txt_add = "#77cc8e", txt_del = "#e06c75", txt_chg = "#52aad8" }
  end
  vim.api.nvim_set_hl(0, "DiffAdd",    { bg = c.add,          fg = c.txt_add, bold = false })
  vim.api.nvim_set_hl(0, "DiffDelete", { bg = c.del,          fg = c.txt_del, bold = false })
  vim.api.nvim_set_hl(0, "DiffChange", { bg = c.chg,          fg = c.txt_chg, bold = false })
  vim.api.nvim_set_hl(0, "DiffText",   { bg = c.chg,          fg = c.txt_chg, bold = true  })
  -- gitsigns uses these groups
  vim.api.nvim_set_hl(0, "GitSignsAdd",          { fg = c.txt_add })
  vim.api.nvim_set_hl(0, "GitSignsChange",       { fg = c.txt_chg })
  vim.api.nvim_set_hl(0, "GitSignsDelete",       { fg = c.txt_del })
  vim.api.nvim_set_hl(0, "GitSignsAddNr",        { fg = c.txt_add })
  vim.api.nvim_set_hl(0, "GitSignsChangeNr",     { fg = c.txt_chg })
  vim.api.nvim_set_hl(0, "GitSignsDeleteNr",     { fg = c.txt_del })
end

-- Apply after every colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_diff_colors })
-- Apply on startup (colorscheme already loaded before this runs)
apply_diff_colors()

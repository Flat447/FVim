-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{ 'phaazon/hop.nvim' },
 	{ 'akinsho/toggleterm.nvim', version = "*", config = true },
	{ 
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"s1n7ax/nvim-window-picker"
		}
	},
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
	config = true
    },
    {
        "uga-rosa/ccc.nvim",
        config = function()
            require("ccc").setup({
                highlighter = {
                    auto_enable = true,
                    lsp = true,
                },
            })
        end
    },
    {
        "sbatin/platformio.nvim",
        dependencies = { "numToStr/FTerm.nvim" }
    },
    {
	    'ellisonleao/glow.nvim',
	    config = function()
		    require('glow').setup({
			    style = 'dark',
		    })
	   end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons'},
        config = function()
            require('lualine').setup()
        end,
    },
    {
       "goolord/alpha-nvim",
       event = "VimEnter",
       dependencies = { "nvim-tree/nvim-web-devicons" }
    },
	{ 'nvim-treesitter/nvim-treesitter' },
        {
         "neovim/nvim-lspconfig",
          event = { "BufReadPre", "BufNewFile" },
          dependencies = {
          -- Mason - управление LSP серверами
          {
             "williamboman/mason.nvim",
              cmd = "Mason",
              opts = {}
      	   },
      	   {
        	"williamboman/mason-lspconfig.nvim",
        	opts = {
        	  auto_install = true,
        	}
      		},
      		-- Completion engine
      		"hrsh7th/nvim-cmp",
      		"hrsh7th/cmp-nvim-lsp",
	    },
	config = function()
      		require("plugins.lsp").setup()
    	 end,
	},
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = true,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, dragon = {}, lotus = {} }
        },
        overrides = function(colors)
          return {
            -- LSP семантические токены
            ["@lsp.type.comment"] = { link = "@comment" },
            ["@lsp.type.enum"] = { link = "@type" },
            ["@lsp.type.interface"] = { link = "@type" },
            ["@lsp.type.keyword"] = { link = "@keyword" },
            ["@lsp.type.namespace"] = { link = "@namespace" },
            ["@lsp.type.parameter"] = { link = "@parameter" },
            ["@lsp.type.property"] = { link = "@property" },
            ["@lsp.type.variable"] = { link = "@variable" },
            
            -- Диагностика LSP
            DiagnosticError = { fg = colors.palette.samuraiRed },
            DiagnosticWarn = { fg = colors.palette.roninYellow },
            DiagnosticInfo = { fg = colors.palette.waveAqua1 },
            DiagnosticHint = { fg = colors.palette.dragonBlue },
          }
        end,
        theme = "dragon",
      })
    end,
  },
  { 
      'catppuccin/nvim',
      name = 'catppuccin',
      priority = 1000
  },
  {
      'ellisonleao/gruvbox.nvim',
      name = 'gruvbox',
      priority = 1000
  },
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-path'},
  {'hrsh7th/cmp-cmdline'},
  {'hrsh7th/nvim-cmp'},
  {'L3MON4D3/LuaSnip'},
  {
      'nvim-telescope/telescope.nvim',
      dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-media-files.nvim'
      }
  },
  {
      "nvimtools/none-ls.nvim",
      dependencies = { "nvim-lua/plenary.nvim" }
  },
  { 
      'windwp/nvim-autopairs',
      config = function()
          require("nvim-autopairs").setup()
        end,
  },
  {
      "numToStr/Comment.nvim",
      lazy = false,
      config = function()
          require("Comment").setup({
              toggler = {
                    line = '<C-_>', -- Ctrl + / на большинстве раскладок
                    block = '<leader>gb',
                },
                opleader = {
                    line = '<C-_>',
                    block = '<leader>gb',
                },
            })
    end
  },
  {
      'akinsho/bufferline.nvim',
      dependencies = {
        'nvim-tree/nvim-web-devicons',
      }
  },
  {
    "famiu/bufdelete.nvim",
    config = function()
      -- Не требует дополнительной настройки
    end,
  },
})

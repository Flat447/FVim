-- lua/config/lsp.lua
local M = {}

function M.setup()
  -- Настройка Mason
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  })

  -- Настройка Mason-lspconfig
  require("mason-lspconfig").setup({
    ensure_installed = {
      "rust_analyzer",
      "clangd",
      "lua_ls"
    },
    automatic_installation = true,
  })

  -- Настройка capabilities для LSP
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- Функция on_attach для всех LSP серверов
  local on_attach = function(client, bufnr)
    -- Включить completion
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Keymaps
    local opts = { buffer = bufnr, noremap = true, silent = true }

    -- Навигация
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    -- Работа с кодом
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    -- Диагностика
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

    -- Информация о сервере
    vim.keymap.set('n', '<space>li', '<cmd>LspInfo<cr>', opts)
  end

  -- Настройка знаков диагностики
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  -- Конфигурация диагностики
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  -- Используем новый API через vim.lsp.start
  -- Настраиваем серверы при подключении через автокоманды

  -- Автокоманда для автоматического запуска LSP серверов
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "rust", "c", "cpp", "lua" },
    callback = function(args)
      local bufnr = args.buf
      local filetype = vim.bo[bufnr].filetype

      local config = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      -- Специфичные настройки для каждого языка
      if filetype == "rust" then
        config.settings = {
          ["rust-analyzer"] = {
            diagnostics = { enable = true },
            cargo = { allFeatures = true },
            checkOnSave = { command = "clippy" },
          }
        }
        vim.lsp.start({
          name = "rust_analyzer",
          cmd = { "rust-analyzer" },
          root_dir = vim.fs.dirname(vim.fs.find({ "Cargo.toml", ".git" }, { upward = true })[1]),
          settings = config.settings,
          on_attach = config.on_attach,
          capabilities = config.capabilities,
        })

      elseif filetype == "c" or filetype == "cpp" then
        config.cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never",
          "--completion-style=detailed",
          "--function-arg-placeholders",
        }
        vim.lsp.start({
          name = "clangd",
          cmd = config.cmd,
          root_dir = vim.fs.dirname(vim.fs.find({ "compile_commands.json", ".git" }, { upward = true })[1]),
          on_attach = config.on_attach,
          capabilities = config.capabilities,
        })

      elseif filetype == "lua" then
        config.settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        }
        vim.lsp.start({
          name = "lua_ls",
          cmd = { "lua-language-server" },
          root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
          settings = config.settings,
          on_attach = config.on_attach,
          capabilities = config.capabilities,
        })
      end
    end,
  })
end

return M

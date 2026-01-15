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
      "lua_ls",
      "hyprls",
      "ruff",
      "pyright",
      "vimls"
    },
    automatic_installation = true,
  })


vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<space>o', vim.diagnostic.open_float)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'lD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'ld', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'lk', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'i', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    
    -- TODO: Используется повторно, необходимо вырезать в след.версии
    -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>r', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
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

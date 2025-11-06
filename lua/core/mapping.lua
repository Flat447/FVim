vim.g.mapleader = " "

vim.keymap.set('n', '<leader>q', ':quit<CR>', opts)
vim.keymap.set('n', '<C-s>', ':write<CR>', opts)

-- Neotree
vim.keymap.set('n', '<leader>e', ':Neotree float focus <CR>')
vim.keymap.set('n', '<leader>o', ':Neotree float git_status<CR>')

-- Glow
vim.keymap.set('n', '<leader>m', ':Glow<CR>', opts)

-- Навигация между буферами
vim.keymap.set("n", "<leader>h", "<Cmd>BufferLineCyclePrev<CR>", opts)
vim.keymap.set("n", "<leader>l", "<Cmd>BufferLineCycleNext<CR>", opts)
      
-- Перемещение буферов
vim.keymap.set("n", "<leader>H", "<Cmd>BufferLineMovePrev<CR>", opts)
vim.keymap.set("n", "<leader>L", "<Cmd>BufferLineMoveNext<CR>", opts)

-- Закрытие буферов
vim.keymap.set("n", "<leader>x", "<Cmd>Bdelete!<CR>", opts)
vim.keymap.set("n", "<leader>bc", "<Cmd>Bdelete!<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>bC", "<Cmd>BufferLineCloseRight<CR>", { desc = "Close buffers to the right" })
vim.keymap.set("n", "<leader>bc", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Close buffers to the left" })

-- Переключение на конкретный буфер по номеру
for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", opts)
end

-- Пин буфера
vim.keymap.set("n", "<leader>p", "<Cmd>BufferLineTogglePin<CR>", opts)

-- Сортировка буферов
vim.keymap.set("n", "<leader>bs", "<Cmd>BufferLineSortByTabs<CR>", { desc = "Sort by tabs" })


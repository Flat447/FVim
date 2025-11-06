local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Header with ASCII art
dashboard.section.header.val = {
    "███████╗██╗   ██╗██╗███╗   ███╗",
    "██╔════╝██║   ██║██║████╗ ████║",
    "█████╗  ██║   ██║██║██╔████╔██║",
    "██╔══╝  ██║   ██║██║██║╚██╔╝██║",
    "██║     ╚██████╔╝██║██║ ╚═╝ ██║",
    "╚═╝      ╚═════╝ ╚═╝╚═╝     ╚═╝",
}
-- Menu buttons
dashboard.section.buttons.val = {
    dashboard.button("e", "[+]  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "[F]  Find file", ":Telescope find_files <CR>"),
    dashboard.button("r", "[R]  Recently files", ":Telescope oldfiles <CR>"),
    dashboard.button("t", "[T]  Find text", ":Telescope live_grep <CR>"),
    dashboard.button("c", "[C]  Configuration", ":e $MYVIMRC <CR>"),
    dashboard.button("q", "[Q]  Quit Neovim", ":qa<CR>"),
}

-- Footer
local function footer()
    local total_plugins = require("lazy").stats().count
    local version = vim.version()
    local datetime = os.date("%Y-%m-%d %H:%M:%S")
    
    return string.format(" %d plugins   v%d.%d.%d   %s", 
        total_plugins, version.major, version.minor, version.patch, datetime)
end

dashboard.section.footer.val = footer()

-- Apply configuration
alpha.setup(dashboard.opts)

-- Disable statusline in dashboard
vim.api.nvim_create_autocmd("FileType", {
    pattern = "alpha",
    callback = function()
        vim.opt.laststatus = 0
        vim.opt.showtabline = 0
    end,
})

-- Restore statusline when leaving dashboard
vim.api.nvim_create_autocmd("BufUnload", {
    buffer = 0,
    callback = function()
        vim.opt.laststatus = 3
        vim.opt.showtabline = 2
    end,
})

require("todo-comments").setup({
    signs = true, -- показывать значки на полях
    sign_priority = 8, -- приоритет знаков
    keywords = {
        FIX = {
            icon = " ", -- иконка для FIX
            color = "error", -- цвет
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- альтернативные ключевые слова
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "! ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    gui_style = {
        fg = "NONE", -- стиль GUI
        bg = "BOLD", -- жирный фон
    },
    merge_keywords = true, -- объединять ключевые слова
    highlight = {
        multiline = true, -- подсвечивать многострочные комментарии
        multiline_pattern = "^.", -- паттерн для многострочных комментариев
        multiline_context = 10, -- контекст для многострочных
        before = "", -- что ставить перед комментарием
        keyword = "wide", -- стиль ключевого слова: "wide", "fg", "bg"
        after = "fg", -- что ставить после комментария
        pattern = [[.*<(KEYWORDS)\s*:]], -- паттерн поиска
        comments_only = true, -- искать только в комментариях
        max_line_len = 400, -- максимальная длина строки
        exclude = {}, -- исключить типы файлов
    },
    colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" }
    },
    search = {
        command = "rg", -- используем ripgrep
        args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
        },
        pattern = [[\b(KEYWORDS):]], -- паттерн для поиска
    },
})

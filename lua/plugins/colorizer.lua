require("colorizer").setup({
  "*", -- применять ко всем файлам
  css = { rgb_fn = true; }, -- дополнительные настройки для CSS
  javascript = { names = false; } -- отключить названия цветов в JS
}, {
  mode = "background", -- или "foreground"
  names = false, -- показывать названия цветов
})

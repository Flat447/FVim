require'nvim-treesitter'.setup {
	ensure_installed = { 'rust', 'typescript', 'lua', 'go', 'python', 'javascript' },

	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
	},
}

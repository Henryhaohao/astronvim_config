---@type LazySpec
return {
  -- 键位提示插件配置
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.keybinding.nvcheatsheet-nvim" },
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<F5>"] = {
            function()
              vim.cmd.Neotree "close"
              require("nvcheatsheet").toggle() -- 打开 nvcheatsheet 键位提示
            end,
            desc = "Cheatsheet",
          },
        },
      },
    },
  },
}

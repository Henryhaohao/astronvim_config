-- vim.api.nvim_set_option_value("clipboard", "unnamedplus", {})
-- vim.opt.clipboard = "unnamedplus"

-- local utils = require "utils"

return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      maps.n["j"] = { "k", desc = "Move cursor up" }
      maps.n["k"] = { "j", desc = "Move cursor down" }

      maps.n["<Leader>nh"] = { ":nohlsearch<CR>", desc = "Close search highlight" }

      maps.n["<C-r>"] = { "<U>", desc = "Redo" }

      maps.v["J"] = { ":move '<-2<CR>gv-gv", desc = "Move line up", silent = true }
      maps.v["K"] = { ":move '>+1<CR>gv-gv", desc = "Move line down", silent = true }

      maps.n["n"] = { "nzz", desc = "Search center" }
      maps.n["N"] = { "Nzz", desc = "Search center" }
      maps.v["n"] = { "nzz", desc = "Search center" }
      maps.v["N"] = { "Nzz", desc = "Search center" }

      maps.n["H"] = { "^", desc = "Go to start without blank" }
      maps.n["L"] = { "$", desc = "Go to end without blank" }

      maps.v["<"] = { "<gv", desc = "Unindent line and keep selection" }
      maps.v[">"] = { ">gv", desc = "Indent line and keep selection" }

      maps.t["<C-w>q"] = {
        [[<C-\><C-n><cmd>close<CR>]],
        desc = "Exit terminal mode and close floating terminal window (enter, press 'i')",
      }
      -- maps.t["<Esc>"] = { [[<C-\><C-n>]], desc = "Exit terminal mode" }
      -- maps.n["<C-w>q"] = { "<cmd>close<CR>", desc = "Close LazyGit floating window" }

      maps.n["<TAB>"] = {
        function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
        desc = "Next buffer tab",
      }
      maps.n["<S-TAB>"] = {
        function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
        desc = "Previous buffer tab",
      }
    end,
  },
}

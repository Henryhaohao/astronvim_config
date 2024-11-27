-- 为 lspkind.nvim 插件定义了图标样式和补全项的截断规则，
-- 通过使用 codicons 图标集和自定义宽度截断，让 LSP 补全项显示更加美观和简洁。
-- 同时，图标映射从 icons/lspkind.lua 中加载，可以灵活地定制不同类型的补全项的图标

---@type LazySpec
return {
  "onsails/lspkind.nvim",
  opts = function(_, opts)
    opts.preset = "codicons"
    opts.symbol_map = require "icons.lspkind"
    opts.before = function(_, vim_item)
      local max_width = math.floor(0.25 * vim.o.columns)
      local label = vim_item.abbr
      local truncated_label = vim.fn.strcharpart(label, 0, max_width)
      if truncated_label ~= label then vim_item.abbr = truncated_label .. "…" end
      return vim_item
    end
    return opts
  end,
}

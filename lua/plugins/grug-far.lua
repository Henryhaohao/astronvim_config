-- 文件内或项目中的搜索和替换功能
-- 类似于 fzf 或 ripgrep 的集成，但支持在多个文件中快速查找和替换内容。
-- 该插件通过 Neovim 的浮动窗口或快速列表显示搜索结果，并提供了多种操作，比如快速定位、历史记录管理、批量替换等。
-- <Leader>s -> <Leader>f / <Leader>r

---@type LazySpec
return {
  "MagicDuck/grug-far.nvim", -- 加载 grug-far.nvim 插件
  cmd = "GrugFar", -- 通过命令 "GrugFar" 启动插件，懒加载模式
  specs = {
    -- 使用 AstroNvim 的图标和核心功能
    {
      "AstroNvim/astroui",
      ---@type AstroUIOpts
      opts = {
        icons = {
          GrugFar = "󰛔", -- 为 GrugFar 设置图标
        },
      },
    },
    {
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        local maps = opts.mappings and opts.mappings or require("astrocore").empty_map_table()
        local prefix = "<Leader>s" -- 设置搜索功能的快捷键前缀为 <Leader>s

        -- 普通模式下的映射，执行搜索和替换功能
        maps.n[prefix] = {
          function()
            local file_path = vim.fn.expand "%:p" -- 获取当前文件的完整路径
            local file_name = vim.fn.fnamemodify(file_path, ":t") -- 获取文件名
            require("grug-far").open { prefills = { search = vim.fn.expand "<cword>", filesFilter = file_name } }
          end,
          desc = require("astroui").get_icon("GrugFar", 1, true) .. "Search and Replace", -- 映射描述
        }

        -- 可视模式下的映射，执行选定内容的搜索和替换
        maps.v[prefix] = {
          function()
            local is_visual = vim.fn.mode():lower():find "v" -- 判断是否处于可视模式
            if is_visual then
              vim.cmd [[normal! v]] -- 保持可视选择模式
            end
            local grug = require "grug-far"
            local file_path = vim.fn.expand "%:p"
            local file_name = vim.fn.fnamemodify(file_path, ":t");

            -- 根据是否在可视模式下执行不同的搜索和替换操作
            (is_visual and grug.with_visual_selection or grug.grug_far) {
              prefills = { filesFilter = file_name },
            }
          end,
          desc = require("astroui").get_icon("GrugFar", 1, true) .. "Search and Replace (current word)",
        }
      end,
    },
    -- 可选插件：copilot 的兼容性处理
    {
      "zbirenbaum/copilot.lua",
      optional = true,
      opts = {
        filetypes = {
          ["grug-far"] = false,
          ["grug-far-history"] = false,
        },
      },
    },
  },
  ---@param opts GrugFarOptionsOverride
  opts = function(_, opts)
    if not opts.icons then opts.icons = {} end
    opts.icons.enabled = vim.g.icons_enabled -- 根据全局图标设置启用/禁用图标
    if not vim.g.icons_enabled then
      opts.resultsSeparatorLineChar = "-" -- 当图标不可用时，设置搜索结果分隔符
      opts.spinnerStates = {
        "|",
        "\\",
        "-",
        "/",
      }
    end

    return require("astrocore").extend_tbl(opts, {
      headerMaxWidth = 80, -- 设置搜索界面的最大宽度
      icons = {
        enabled = vim.g.icons_enabled,
      },
      keymaps = {
        replace = { n = "<localleader>r" }, -- 替换快捷键
        qflist = { n = "<localleader>c" }, -- 显示快速列表快捷键
        syncLocations = { n = "<localleader>s" }, -- 同步搜索位置快捷键
        syncLine = { n = "<localleader>l" }, -- 同步到当前行快捷键
        close = { n = "q" }, -- 关闭窗口快捷键
        historyOpen = { n = "<localleader>t" }, -- 打开历史记录快捷键
        historyAdd = { n = "<localleader>a" }, -- 添加到历史记录快捷键
        refresh = { n = "<localleader>f" }, -- 刷新搜索结果快捷键
        openLocation = { n = "<localleader>o" }, -- 打开位置快捷键
        gotoLocation = { n = "<enter>" }, -- 跳转到位置快捷键
        pickHistoryEntry = { n = "<enter>" }, -- 选择历史记录快捷键
        abort = { n = "<localleader>b" }, -- 中止操作快捷键
        help = { n = "g?" }, -- 显示帮助快捷键
        toggleShowRgCommand = { n = "<localleader>p" }, -- 切换显示 rg 命令
      },
      startInInsertMode = false, -- 不在插入模式下启动
    })
  end,
}

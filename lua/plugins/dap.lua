-- DAP（调试适配协议） 插件
-- 为调试提供了多个快捷键和功能，并集成了多个辅助插件，如 persistent-breakpoints 和 nvim-dap-ui。
-- 目的是为 Neovim 用户提供一个完整的UI调试环境。
--[[
配置了 Neovim 的 **DAP（调试适配协议）** 插件，为调试提供了多个快捷键和功能，并集成了多个辅助插件，如 **persistent-breakpoints** 和 **nvim-dap-ui**。主要目的是为 Neovim 用户提供一个完整的调试环境。

### 功能解析：

1. **快捷键映射**：
   - 快捷键以 `<Leader>d` 为前缀，提供了常用的调试操作，如：
     - `dq` 终止调试会话（等同于 `Shift + F5`）
     - `dQ` 关闭调试会话
     - `dj` 下移堆栈帧
     - `dk` 上移堆栈帧
     - `dp` 预览当前变量值
     - `dP` 暂停执行（等同于 `F6`）
     - `dR` 重启（等同于 `Ctrl + F5`）

2. **断点管理**：
   - `F9` 或 `<Leader>db` 切换断点。
   - `<Leader>dB` 清除所有断点。
   - `Shift + F9` 或 `<Leader>dC` 设置条件断点。
   
3. **调试 UI 操作**：
   - `<Leader>du` 切换调试 UI 界面。
   - `<Leader>dU` 切换所有调试 UI 界面并重置布局。

4. **其他调试辅助**：
   - `<Leader>ds` 切换调试会话。
   - `<Leader>dr` 重新运行上次的调试。
   - `<Leader>dG` 创建调试配置文件 `launch.json`。

5. **插件集成**：
   - **persistent-breakpoints**：用于在会话之间持久化断点。可以自动加载保存的断点，尤其适用于调试多个文件时保持断点一致性。
   - **nvim-dap-ui**：为 DAP 提供用户界面，自动在调试开始时显示 UI，便于查看变量、堆栈和控制调试流。
   - **nvim-dap-virtual-text**：在代码行旁边显示虚拟文本，帮助查看变量值变化和停止原因等。
   - **nvim-dap-repl-highlights**：为调试 REPL 提供语法高亮。

### 总结：
该配置通过丰富的快捷键和插件集成，为 Neovim 提供了类似 IDE 的调试体验，适合需要调试多种语言的开发者。
--]]

-- TODO: auto set up filename as debug name
local utils = require "astrocore"
local prefix_debug = "<Leader>d"
---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          [prefix_debug .. "q"] = {
            function() require("dap").terminate() end,
            desc = "Terminate Session (S-F5)",
          },
          [prefix_debug .. "Q"] = {
            function() require("dap").close() end,
            desc = "Close Session",
          },
          [prefix_debug .. "j"] = {
            function() require("dap").down() end,
            desc = "Down Strace",
          },
          [prefix_debug .. "k"] = {
            function() require("dap").up() end,
            desc = "Up Strace",
          },
          [prefix_debug .. "p"] = {
            function() require("dap.ui.widgets").preview() end,
            desc = "Debugger Preview",
          },
          [prefix_debug .. "P"] = { function() require("dap").pause() end, desc = "Pause (F6)" },
          [prefix_debug .. "u"] = {
            function() require("dapui").toggle { layout = 2, reset = true } end,
            desc = "Toggle Tray Debugger UI and reset layout",
          },
          [prefix_debug .. "U"] = {
            function() require("dapui").toggle { reset = true } end,
            desc = "Toggle All Debugger UI and reset layout",
          },
          [prefix_debug .. "r"] = {
            function() require("dap").run_last() end,
            desc = "Run Last",
          },
          [prefix_debug .. "R"] = {
            function() require("dap").restart_frame() end,
            desc = "Restart (C-F5)",
          },
          [prefix_debug .. "d"] = {
            ---@diagnostic disable-next-line: missing-parameter
            function() require("dapui").float_element() end,
            desc = "Open Dap UI Float Element",
          },
          ["<F9>"] = {
            function() require("persistent-breakpoints.api").toggle_breakpoint() end,
            desc = "Debugger: Toggle Breakpoint",
          },
          [prefix_debug .. "b"] = {
            function() require("persistent-breakpoints.api").toggle_breakpoint() end,
            desc = "Toggle Breakpoint (F9)",
          },
          [prefix_debug .. "B"] = {
            function() require("persistent-breakpoints.api").clear_all_breakpoints() end,
            desc = "Clear All Breakpoints",
          },
          [prefix_debug .. "C"] = {
            function() require("persistent-breakpoints.api").set_conditional_breakpoint() end,
            desc = "Conditional Breakpoint (S-F9)",
          },
          ["<F21>"] = {
            function() require("persistent-breakpoints.api").set_conditional_breakpoint() end,
            desc = "Conditional Breakpoint (S-F9)",
          },
          [prefix_debug .. "S"] = {
            function() require("dap").run_to_cursor() end,
            desc = "Run To Cursor",
          },
          [prefix_debug .. "s"] = {
            function()
              local w = require "dap.ui.widgets"
              w.centered_float(w.sessions, {})
            end,
            desc = "Switch Debug Session",
          },
          [prefix_debug .. "G"] = {
            require("utils").create_launch_json,
            desc = "Create Dap Launch Json",
          },
          ["gh"] = { function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover" },
        },
      },
    },
  },
  { "jay-babu/mason-nvim-dap.nvim", optional = true },
  {
    "Weissle/persistent-breakpoints.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        load_breakpoints_event = { "BufReadPost" },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "LiadOz/nvim-dap-repl-highlights",
      dependencies = { "mfussenegger/nvim-dap" },
      opts = {},
    },
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "dap_repl" })
      end
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
    event = "User AstroFile",
    opts = {
      commented = true,
      enabled = true,
      enabled_commands = true,
      only_first_definition = true,
      clear_on_continue = false,
      highlight_changed_variables = true,
      all_frames = false,
      virt_lines = true,
      show_stop_reason = true,
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function(_, opts)
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.after.event_initialized["dapui_config"] = function()
        require("dapui").open { layout = 2, reset = true }
      end
      dapui.setup(opts)
    end,
  },
}

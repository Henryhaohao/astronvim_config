-- Refer: https://docs.astronvim.com/recipes/neovide/

if not vim.g.neovide then
  return {} -- do nothing if not in a neovide session
end

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      opt = { -- configure vim.opt options
        -- configure font
        guifont = "JetBrainsMono Nerd Font:h14",
        -- line spacing
        linespace = 0,
      },
      g = { -- configure vim.g variables
        neovide_fullscreen = true,
        neovide_no_idle = true, -- 不会进入空闲状态，持续渲染，减少视觉滞后，提高动画流畅度
        neovide_confirm_quit = true,
        -- configure scalling
        neovide_scale_factor = 1.0,
        -- configure padding
        neovide_padding_top = 3,
        neovide_padding_botton = 0,
        neovide_padding_right = 0,
        neovide_padding_left = 0,
      },
    },
  },
}

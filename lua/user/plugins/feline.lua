return function(config)
  local C = require("gruvbox.palette")
  local hl = require("core.status").hl
  local provider = require("core.status").provider
  local conditional = require("core.status").conditional
  local vi_mode = require("feline.providers.vi_mode")
  local git_bg = C.dark2
  config.theme = {
    fg = C.light4,
    bg = C.dark1,
  }
  config.vi_mode_colors = {
      -- NORMAL = ,
      -- OP = ,
      -- INSERT = ,
      -- VISUAL = ,
      -- BLOCK = ,
      -- REPLACE = ,
      -- ["V-REPLACE"] = ,
      -- ENTER = ,
      -- MORE = ,
      -- SELECT = ,
      -- COMMAND = ,
      -- SHELL = ,
      -- TERM = ,
      -- NONE = ,
  }
  local components = {
    {
      {
        provider = function()
          return " " .. vi_mode.get_vim_mode() .. " "
        end,
        hl = function()
          local mode = hl.mode()()
          mode["style"] = "bold"
          return mode
        end,
        style = "bold",
      },
      { provider = provider.spacer(1), hl = { bg = git_bg }, enabled = conditional.git_available },
      {
        provider = "git_branch", hl = { fg = C.bright_aqua, bg = git_bg }, icon = " " },
      {
        provider = provider.spacer(1),
        hl = { bg = git_bg },
        enabled = function()
          return conditional.git_available() and not conditional.git_changed()
        end,
      },
      { provider = "git_diff_added", hl = { fg = C.bright_green, bg = git_bg }, icon = " +" }, -- 
      { provider = "git_diff_changed", hl = { fg = C.bright_orange, bg = git_bg }, icon = " ~" }, -- 柳
      { provider = "git_diff_removed", hl = { fg = C.bright_red, bg = git_bg }, icon = " -" }, -- 
      { provider = provider.spacer(1), hl = { bg = git_bg }, enabled = conditional.git_changed },
      { provider = provider.spacer(1) },
      { provider = { name = "file_info", opts = { type = "relative", file_modified_icon = "", file_readonly_icon = " " }}, hl = { fg = C.light4 }, icon = "" },
      {
        provider = " δ",
        hl = { fg = "orange", style = "bold" },
        enabled = function()
          return vim.bo.modified
        end,
      },
      { provider = "diagnostic_errors", hl = hl.fg("DiagnosticError"), icon = "  " },
      { provider = "diagnostic_warnings", hl = hl.fg("DiagnosticWarn"), icon = "  " },
      { provider = "diagnostic_info", hl = hl.fg("DiagnosticInfo"), icon = "  " },
      { provider = "diagnostic_hints", hl = hl.fg("DiagnosticHint"), icon = "  " },
    },
    {
      { provider = { name = "file_type", opts = { filetype_icon = true, case = "lowercase" } }, hl = { fg = C.light4 }, enabled = conditional.has_filetype },
      { provider = provider.spacer(1), enabled = conditional.has_filetype },
      { provider = provider.lsp_progress, hl = { fg = C.light4 }, enabled = conditional.bar_width() },
      { provider = provider.lsp_client_names(true), short_provider = provider.lsp_client_names(), hl = { fg = C.light4 }, enabled = conditional.bar_width(), icon = "   " },
      { provider = provider.spacer(1), enabled = conditional.bar_width() },
      { provider = provider.treesitter_status, enabled = conditional.bar_width(), hl = hl.fg("GitSignsAdd", { fg = C.green }) },
      { provider = provider.spacer(2), },
      { provider = "position", hl = { fg = C.light4 } },
      { provider = provider.spacer() },
      {
        provider = "scroll_bar",
        hl = function()
          local mode = hl.mode()()
          return { fg = mode.bg, bg = mode.fg }
        end,
      },
    }
  }
  config.components = {
    active = components,
    inactive = components,
  }
  return config
end

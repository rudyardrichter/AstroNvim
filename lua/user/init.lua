return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "nightly", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    -- remotes = { -- easily add new remotes to track
    --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
    --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
    --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    -- },
  },

  colorscheme = "gruvbox",

  -- set vim options here (vim.<first_key>.<second_key> =  value)
  options = {
    g = {
      mapleader = " ",
    },
  },

  -- Configure plugins
  plugins = {
    -- Add plugins, the packer syntax without the "use"
    init = {
      ["akinsho/bufferline.nvim"] = { disable = true },

      { "Vimjas/vim-python-pep8-indent", ft = "python" },
      { "ellisonleao/gruvbox.nvim" },
      { "rudyardrichter/pretty-fold.nvim" },
      { "tmhedberg/SimpylFold" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "lervag/vimtex" },
      {
        "pwntester/octo.nvim",
        config = function()
          require("octo").setup()
        end,
      },
      { "mong8se/actually.nvim" },
      {
        "folke/trouble.nvim",
        config = function()
          require("trouble").setup{
          }
        end
      },
    },
    ["null-ls"] = function(config)
      ---@diagnostic disable-next-line: different-requires
      local null_ls = require "null-ls"
      local h = require 'null-ls.helpers'
      local blackd = {
        name = 'blackd',
        method = null_ls.methods.FORMATTING,
        filetypes = { 'python' },
        generator = h.formatter_factory {
          command = 'blackd-client',
          to_stdin = true,
        },
      }

      config.sources = {
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.rufo,
        null_ls.builtins.diagnostics.rubocop,
        blackd,
      }
      -- set up null-ls's on_attach function
      config.on_attach = function(client)
        -- NOTE: You can remove this on attach function to disable format on save
        if client.resolved_capabilities.document_formatting then
          vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Auto format before save",
            pattern = "<buffer>",
            callback = vim.lsp.buf.formatting_sync,
          })
        end
      end
      return config -- return final config table
    end,
    aerial = {
      on_attach = function(bufnr)
      end,
    },
    cinnamon = {
      default_delay = 2,
    },
    cmp = function(opts)
      opts["source_priority"] = {
        nvim_lsp = 1000,
        luasnip = 750,
        buffer = 500,
        path = 250,
      }
      opts["sources"] = {
        { name = 'nvim_lsp_signature_help' }
      }
      opts["mapping"]["<C-j>"] = nil
      opts["mapping"]["<C-k>"] = nil
      return opts
    end,
    treesitter = {
      ensure_installed = { "lua" },
    },
    ["nvim-lsp-installer"] = {
      ensure_installed = { "sumneko_lua" },
    },
    packer = {
      compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
    },
    telescope = {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim" -- add this value
        },
      },
    },
  },

  luasnip = {
    -- Add paths for including more VS Code style snippets in luasnip
    vscode_snippet_paths = {},
    filetype_extend = {
      javascript = { "javascriptreact" },
    },
  },

  ["which-key"] = {
    register_mappings = {
      n = {
        ["<leader>"] = {
          -- which-key registration table for normal mode, leader prefix
          -- ["N"] = { "<cmd>tabnew<cr>", "New Buffer" },
        },
      },
    },
  },

  -- Extend LSP configuration
  lsp = {
    -- enable servers that you already have installed without lsp-installer
    -- servers = {
    --   "pyright",
    -- },
    -- add to the server on_attach function
    -- on_attach = function(client, bufnr)
    -- end,

    -- override the lsp installer server-registration function
    -- server_registration = function(server, opts)
    --   require("lspconfig")[server].setup(opts)
    -- end,

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
      -- example for addings schemas to yamlls
      -- yamlls = {
      --   settings = {
      --     yaml = {
      --       schemas = {
      --         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      --         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      --         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      --       },
      --     },
      --   },
      -- },
      -- pyright = {
      --   settings = {
      --     python = {
      --       analysis = {
      --         typeCheckingMode = "on",
      --       }
      --     }
      --   }
      -- }
    },
  },

  -- Diagnostics configuration (for vim.diagnostics.config({}))
  diagnostics = {
    virtual_text = { prefix = "❯" },
    underline = true,
    update_in_insert = false,
  },

  polish = function()
    vim.api.nvim_create_augroup("packer_conf", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })

    require('pretty-fold').setup{
      add_close_pattern = true,
      fill_char = '·',
      fill_left = false,
      keep_indentation = true,
      sections = {
        left = {
          'content',
        },
        right = {
          '┃ ', 'number_of_folded_lines', ': ', 'percentage', ' ┃ ',
        }
      }
    }
    -- require("py_lsp").setup{}
    local nvim_lsp = require("lspconfig")
    local lsp_util = require("lspconfig/util")
    local find_cmd = function(cmd, prefixes, start_from, stop_at)
      local path = require("lspconfig/util").path

      if type(prefixes) == "string" then
        prefixes = { prefixes }
      end

      local found
      for _, prefix in ipairs(prefixes) do
        local full_cmd = prefix and path.join(prefix, cmd) or cmd
        local possibility

        -- if start_from is a dir, test it first since transverse will start from its parent
        if start_from and path.is_dir(start_from) then
          possibility = path.join(start_from, full_cmd)
          if vim.fn.executable(possibility) > 0 then
            found = possibility
            break
          end
        end

        path.traverse_parents(start_from, function(dir)
          possibility = path.join(dir, full_cmd)
          if vim.fn.executable(possibility) > 0 then
            found = possibility
            return true
          end
          -- use cwd as a stopping point to avoid scanning the entire file system
          if stop_at and dir == stop_at then
            return true
          end
        end)

        if found ~= nil then
          break
        end
      end
      return found or cmd
    end

    nvim_lsp.pyright.setup({
      before_init = function(_, config)
        local p
        if vim.env.VIRTUAL_ENV then
          p = lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
        else
          p = find_cmd("python3", ".venv/bin", config.root_dir)
        end
        config.settings.python.pythonPath = p
      end,
      -- on_attach = require("completion").on_attach
      settings = {
        disableOrganizeImports = true,
      },
    })

    local palette = require("gruvbox.palette")
    require("gruvbox").setup({
      inverse = false,
      overrides = {
        GruvboxRedSign = { bg = palette.dark0 },
        GruvboxGreenSign = { bg = palette.dark0 },
        GruvboxYellowSign = { bg = palette.dark0 },
        GruvboxBlueSign = { bg = palette.dark0 },
        GruvboxPurpleSign = { bg = palette.dark0 },
        GruvboxAquaSign = { bg = palette.dark0 },
        GruvboxOrangeSign = { bg = palette.dark0 },
        Folded = { bg = palette.dark0 },
        Pmenu = { bg = palette.dark0 },
        IncSearch = { fg = palette.dark1, bg = palette.bright_blue },
        Search = { fg = palette.dark0, bg = palette.bright_yellow },
        SignColumn = { bg = palette.dark0 },
        String = { italic = false },
      }
    })
    vim.cmd("colorscheme gruvbox")

    vim.cmd("highlight IndentBlanklineContextChar guifg=" .. palette.dark4)
  end,
}

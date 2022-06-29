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
      { "anuvyklack/pretty-fold.nvim" },
      { "tmhedberg/SimpylFold" },
    },
    ["cmp"] = {
      sources = {
        { name = 'nvim_lsp_signature_help' },
      },
      mapping = {
        -- These don't work?
        ["<C-j>"] = nil,
        ["<C-k>"] = nil,
      },
    },
    ["null-ls"] = function(config)
      ---@diagnostic disable-next-line: different-requires
      local null_ls = require "null-ls"
      config.sources = {
        -- Set a formatter
        null_ls.builtins.formatting.rufo,
        -- Set a linter
        null_ls.builtins.diagnostics.rubocop,
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
      link_folds_to_tree = true,
    },
    cinnamon = {
      default_delay = 2,
    },
    treesitter = {
      ensure_installed = { "lua" },
    },
    ["nvim-lsp-installer"] = {
      ensure_installed = { "sumneko_lua" },
    },
    packer = {
      compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
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

  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },

  -- Extend LSP configuration
  lsp = {
    -- enable servers that you already have installed without lsp-installer
    servers = {
      -- "pyright"
    },
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
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "on",
            }
          }
        }
      }
    },
  },

  -- Diagnostics configuration (for vim.diagnostics.config({}))
  diagnostics = {
    virtual_text = { prefix = "❯" },
    underline = true,
    update_in_insert = true,
  },

  polish = function()
    vim.api.nvim_create_augroup("packer_conf", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })

    vim.cmd("highlight IndentBlanklineContextChar guifg=" .. palette.dark4)
    require('pretty-fold').setup{
      add_close_pattern = true,
      keep_indentation = true,
      fill_char = '━',
      sections = {
        left = {
          'content', '┣'
        },
        right = {
          '┫ ', 'number_of_folded_lines', ': ', 'percentage', ' ┃ ',
        }
      }
    }
  end,
}

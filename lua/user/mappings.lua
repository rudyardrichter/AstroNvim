return {
  n = {
    ["<cr>"] = { "<cmd>w<cr>" },
    ["<tab>"] = { "za" },

    ["n"] = { "nzz" },
    ["N"] = { "Nzz" },

    [";"] = { ":", noremap = true },
    ["Q"] = { "<cmd>q<cr>" },
    ["H"] = { "^", noremap = true },
    ["J"] = { "mjJ`j" },
    ["L"] = { "$", noremap = true },
    ["Y"] = { "y$" },

    ["<Up>"] = { "<C-w>k", noremap = true },
    ["<Down>"] = { "<C-w>j", noremap = true },
    ["<Left>"] = { "<C-w>h", noremap = true },
    ["<Right>"] = { "<C-w>l", noremap = true },

    ["<C-h>"] = { "<C-o>", noremap = true },
    ["<C-j>"] = { "<C-e>", noremap = true },
    ["<C-k>"] = { "<C-y>", noremap = true },
    ["<C-l>"] = { "<C-i>", noremap = true },

    ["<C-q>"] = { "<cmd>Telescope diagnostics bufnr=0<cr>" },

    ["<C-z>"] = {"&foldlevel ? 'zM' :'zR'", expr = true},

    ["<C-f>"] = {
      function()
        require("telescope.builtin").find_files()
      end,
    },
    ["<C-s>"] = {
      function()
        require("telescope.builtin").live_grep()
        -- require("telescope.builtin").live_grep({["additional_args"] = "-i"})
      end,
    },
    ["<C-p>"] = {
      function()
        require("telescope.builtin").buffers()
      end,
    },

    ["<C-_>"] = { '<cmd>let @/=""<CR><C-l>', silent = true },

    ["<leader>d"] = {
      function()
        vim.lsp.buf.definition()
      end,
      desc = "Show the definition of current symbol",
    },
    ["<leader>h"] = { "mh*`h" },
    ["<leader>rw"] = { "<cmd>%s/\\s\\+$//<CR> <cmd>nohl<CR> <cmd>w<CR>" }
  },
  i = {
    ["<C-j>"] = { "<C-c><cmd>w<cr>", noremap = true }
  },
  c = {
    ["<C-l>"] = {'wildmenumode() ? "\\<Down>" : "\\<C-l>"', expr = true, noremap = true},
  },
  v = {
    [";"] = { ":", noremap = true },
    ["H"] = { "^" },
    ["L"] = { "$" },
    ["<C-j>"] = { "<C-e>", noremap = true },
    ["<C-k>"] = { "<C-y>", noremap = true },
  },
}

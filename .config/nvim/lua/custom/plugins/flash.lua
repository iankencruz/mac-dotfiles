return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {
    modes = {
      search = {
        -- when `true`, flash will be activated during regular search by default.
        -- You can always toggle when searching with `require("flash").toggle()`
        enabled = true,
        highlight = { backdrop = true },
        jump = { history = true, register = true, nohlsearch = true },
        search = {
          -- `forward` will be automatically set to the search direction
          -- `mode` is always set to `search`
          -- `incremental` is set to `true` when `incsearch` is enabled
        },
      },
    },
    -- options used for treesitter selections
    -- `require("flash").treesitter()`
    treesitter = {
      labels = 'abcdefghijklmnopqrstuvwxyz',
      jump = { pos = 'range', autojump = true },
      search = { incremental = false },
      label = { before = true, after = true, style = 'inline' },
      highlight = {
        backdrop = false,
        matches = false,
      },
    },
    treesitter_search = {
      jump = { pos = 'range' },
      search = { multi_window = true, wrap = true, incremental = false },
      remote_op = { restore = true },
      label = { before = true, after = true, style = 'inline' },
    },
  },
  -- stylua: ignore
  keys = {
    { "f", mode = { "n", "x", "o" }, function() require("flash").jump({search = { forward = true, wrap = false, multi_window = false }}) end, desc = "Flash" },
    { "F", mode = { "n", "x", "o" }, function() require("flash").jump({search = { forward = false, wrap = false, multi_window = false }}) end, desc = "Flash" },

    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}

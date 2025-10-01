return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('catppuccin').setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = true, -- disables setting the background color.
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { 'italic' }, -- Change the style of comments
          conditionals = { 'italic' },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {
          all = {
            -- Override all flavours with TNB colors
            -- Deep & Saturated Tones (High Priority/Keywords)
            deep_red = '#c94632', -- Deep, rich red (main keywords)
            muted_brick = '#e65e4e', -- Saturated brick-red (conditionals)
            dark_coral = '#e28c61', -- Deeper muted red (constants)

            -- Mid-Range Tones (Functions, Types, Built-ins)
            bright_coral = '#f17e65', -- Brighter mid-tone coral (built-ins)
            mid_tangerine = '#e98877', -- Brighter pastel red-orange (types)
            soft_salmon = '#f59a8c', -- Lighter coral red/salmon (operators)

            -- Light & Pastel Tones (Strings, Variables, Imports)
            light_peach = '#f7b09b', -- True peachy-orange (functions)
            pastel_orange = '#f9c2ae', -- Soft muted orange (numbers)
            warm_cream = '#fbd4c3', -- Light rose-pink/pastel (variables)
            golden_cream = '#fde5d3', -- Soft golden cream (strings)
            very_light_cream = '#fcf0e4', -- Very light warm cream (imports)

            -- Near-Neutral/Grayscale Tones (Subtle UI elements/Punctuation)
            medium_rose = '#db7979', -- Medium rose-red (Original sapphire equivalent)
            light_rose = '#d9a8a8', -- Light muted pink-red (Original flamingo equivalent)
            pure_white = '#ffffff', -- White (Original rosewater equivalent)

            -- Surface colors for UI elements
            surface0 = '#333333', -- slightly lighter than base
            surface1 = '#444444', -- palette 8
            surface2 = '#666666', -- medium gray
            overlay0 = '#888888', -- palette 12 equivalent
            overlay1 = '#aaaaaa', -- palette 12
            overlay2 = '#cccccc', -- palette 7

            -- Subdued text colors
            subtext0 = '#888888',
            subtext1 = '#aaaaaa',
          },
        },
        custom_highlights = function(colors)
          return {
            -- Deep & Saturated Tones for Keywords and Conditionals
            ['@keyword'] = { fg = colors.deep_red, style = { 'italic' } },
            ['@keyword.conditional'] = { fg = colors.muted_brick, style = { 'italic' } },
            ['@keyword.repeat'] = { fg = colors.muted_brick, style = { 'italic' } },
            ['@keyword.function'] = { fg = colors.deep_red, style = { 'italic' } },
            ['@keyword.operator'] = { fg = colors.soft_salmon }, -- Mid-Range for operators
            ['@keyword.import'] = { fg = colors.very_light_cream }, -- Very Light for imports

            -- Mid-Range Tones for Functions and Types
            ['@function'] = { fg = colors.light_peach },
            ['@function.builtin'] = { fg = colors.bright_coral },
            ['@function.call'] = { fg = colors.light_peach },

            ['@type'] = { fg = colors.mid_tangerine },
            ['@type.builtin'] = { fg = colors.mid_tangerine },
            ['@type.definition'] = { fg = colors.mid_tangerine },

            -- Light & Pastel Tones for Variables, Strings, and Numbers
            ['@variable'] = { fg = colors.warm_cream },
            ['@variable.builtin'] = { fg = colors.warm_cream },
            ['@variable.parameter'] = { fg = colors.text }, -- Assuming 'text' is a defined foreground color

            ['@constant'] = { fg = colors.dark_coral },
            ['@constant.builtin'] = { fg = colors.dark_coral },
            ['@string'] = { fg = colors.golden_cream },
            ['@number'] = { fg = colors.pastel_orange },
            ['@boolean'] = { fg = colors.dark_coral },

            -- Operators and Punctuation
            ['@operator'] = { fg = colors.soft_salmon },
            ['@punctuation.delimiter'] = { fg = colors.text },
            ['@punctuation.bracket'] = { fg = colors.text },

            -- Comments
            ['@comment'] = { fg = colors.overlay1, style = { 'italic' } },

            -- Telescope integration
            TelescopeBorder = { fg = colors.deep_red },
            TelescopePromptBorder = { fg = colors.deep_red },
            TelescopeSelection = { fg = colors.deep_red, bg = colors.surface0 },

            -- LSP and diagnostics
            DiagnosticError = { fg = colors.deep_red },
            DiagnosticWarn = { fg = colors.golden_cream },
            DiagnosticInfo = { fg = colors.bright_coral },
            DiagnosticHint = { fg = colors.overlay1 },
          }
        end,
        default_integrations = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          telescope = { enabled = true },
          mini = {
            enabled = true,
            indentscope_color = '',
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et

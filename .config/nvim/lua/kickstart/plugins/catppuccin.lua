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
            text = '#e0e0e0', -- foreground
            base = '#000000', -- background (pure black)
            mantle = '#2a2a2a', -- palette 0 (dark gray)
            crust = '#444444', -- palette 8 (medium gray)

            -- Pastel warm colors with more red variety
            red = '#d47a7a', -- soft coral-red (main keywords)
            maroon = '#c66666', -- true pastel red (conditionals)
            peach = '#e6a085', -- peachy-orange (functions)
            yellow = '#f2d49b', -- soft golden cream (strings)
            green = '#cc7766', -- brighter pastel red-orange (types)
            teal = '#cc8888', -- light rose-red (operators)
            sky = '#f0d6a6', -- very light warm cream (imports)
            sapphire = '#aaaaaa', -- palette 12 (medium-light gray)
            blue = '#d99999', -- soft pink-red (built-ins)
            lavender = '#e6b3b3', -- light rose-pink (variables)
            mauve = '#a66666', -- deeper muted red (constants)
            pink = '#e8a6a6', -- warm pastel pink (numbers)
            flamingo = '#cccccc', -- palette 7 (light gray)
            rosewater = '#ffffff', -- palette 15 (white)

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
            -- Go/Programming syntax with orange variety
            ['@keyword'] = { fg = colors.red, style = { 'italic' } }, -- #ff4422 main keywords (func, type, var)
            ['@keyword.conditional'] = { fg = colors.maroon, style = { 'italic' } }, -- #ee3322 if/else
            ['@keyword.repeat'] = { fg = colors.maroon, style = { 'italic' } }, -- #ee3322 for/while loops
            ['@keyword.function'] = { fg = colors.red, style = { 'italic' } }, -- #ff4422 func keyword
            ['@keyword.operator'] = { fg = colors.teal }, -- #ff5533 operators
            ['@keyword.import'] = { fg = colors.blue }, -- #ff7744 import/package

            ['@function'] = { fg = colors.peach }, -- #ff6633 function names
            ['@function.builtin'] = { fg = colors.blue }, -- #ff7744 built-in functions
            ['@function.call'] = { fg = colors.peach }, -- #ff6633 function calls

            ['@type'] = { fg = colors.green }, -- #ff8844 type names
            ['@type.builtin'] = { fg = colors.green }, -- #ff8844 built-in types
            ['@type.definition'] = { fg = colors.green }, -- #ff8844 type definitions

            ['@variable'] = { fg = colors.lavender }, -- #ff5544 variables
            ['@variable.builtin'] = { fg = colors.lavender }, -- #ff5544 built-in vars
            ['@variable.parameter'] = { fg = colors.text }, -- #e0e0e0 parameters

            ['@constant'] = { fg = colors.mauve }, -- #ff9955 constants
            ['@constant.builtin'] = { fg = colors.mauve }, -- #ff9955 built-in constants
            ['@string'] = { fg = colors.yellow }, -- #ffcc66 strings
            ['@number'] = { fg = colors.mauve }, -- #ff9955 numbers
            ['@boolean'] = { fg = colors.mauve }, -- #ff9955 true/false

            ['@operator'] = { fg = colors.teal }, -- #ff5533 operators
            ['@punctuation.delimiter'] = { fg = colors.text }, -- #e0e0e0 commas, semicolons
            ['@punctuation.bracket'] = { fg = colors.text }, -- #e0e0e0 brackets, parens

            ['@comment'] = { fg = colors.overlay1, style = { 'italic' } }, -- #aaaaaa comments

            -- Telescope integration
            TelescopeBorder = { fg = colors.red },
            TelescopePromptBorder = { fg = colors.red },
            TelescopeSelection = { fg = colors.red, bg = colors.surface0 },

            -- LSP and diagnostics
            DiagnosticError = { fg = colors.red },
            DiagnosticWarn = { fg = colors.yellow },
            DiagnosticInfo = { fg = colors.peach },
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

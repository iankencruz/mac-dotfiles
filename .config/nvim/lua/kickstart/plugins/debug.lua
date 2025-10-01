-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python', -- Add Python debugger support

    -- json5
    'Joakker/lua-json5', -- Make sure this line exists
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<leader>dd',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<Right>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<Down>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<Left>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
    -- Python-specific keymaps
    {
      '<leader>dpt',
      function()
        require('dap-python').test_method()
      end,
      desc = 'Debug: Test Method',
      ft = 'python',
    },
    {
      '<leader>dpc',
      function()
        require('dap-python').test_class()
      end,
      desc = 'Debug: Test Class',
      ft = 'python',
    },
    {
      '<leader>dps',
      function()
        require('dap-python').debug_selection()
      end,
      desc = 'Debug: Debug Selection',
      ft = 'python',
      mode = 'v',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'debugpy', -- Add debugpy for Python debugging
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Load launch.json configurations from .vscode/launch.json
    -- This will look for launch.json in the current working directory
    require('dap.ext.vscode').load_launchjs(nil, {
      go = { 'go', 'golang' },
      python = { 'python', 'py' }, -- Add Python support for launch.json
    })

    vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#ffcc00' })
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '◉', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '○', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DapStopped', numhl = 'DapStopped' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Configure Python debugging with debugpy
    require('dap-python').setup '~/.virtualenvs/debugpy/bin/python'
    -- Alternative setup options:
    -- require('dap-python').setup('python3') -- Use system python3
    -- require('dap-python').setup('/usr/bin/python3') -- Use specific python path
    -- require('dap-python').setup(vim.fn.exepath('python3')) -- Use python3 in PATH

    -- Custom Python DAP configuration (optional - nvim-dap-python provides good defaults)
    dap.configurations.python = dap.configurations.python or {}
    table.insert(dap.configurations.python, {
      type = 'python',
      request = 'launch',
      name = 'Launch file with arguments',
      program = '${file}',
      args = function()
        local args_string = vim.fn.input 'Arguments: '
        return vim.split(args_string, ' ')
      end,
      console = 'integratedTerminal',
      cwd = '${workspaceFolder}',
      env = {
        PYTHONPATH = '${workspaceFolder}',
      },
    })

    -- Enable verbose logging for debugging
    vim.fn.setenv('NVIM_DAP_LOG_LEVEL', 'DEBUG')

    -- Add error handling and logging
    dap.listeners.after.event_output['dap_log'] = function(session, body)
      if body.category == 'stderr' then
        print('DAP Error: ' .. body.output)
      end
    end
  end,
}

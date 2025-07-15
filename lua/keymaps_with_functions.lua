-- vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
-- require('Undotree').load 'wave'
-- g:undotree_WindowLayout = 1
local group = vim.api.nvim_create_augroup('jump_last_position', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
    if { row, col } ~= { 0, 0 } then
      vim.api.nvim_win_set_cursor(0, { row, 0 })
    end
  end,
  group = group,
})

-- Remove whitespace on save
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  callback = function()
    local save_cursor = vim.fn.getpos '.'
    vim.cmd [[%s/\s\+$//e]]
    vim.fn.setpos('.', save_cursor)
  end,
})
-- Oil at workspace directory
vim.keymap.set('n', '<leader>f', function()
  require('oil').open '.'
  vim.opt.colorcolumn = ''
end, { desc = 'toggle oil tree' })

vim.keymap.set('n', '<leader>F', function()
  local current_file = vim.fn.expand '%:p' -- Get the full path of the current file
  local current_dir = vim.fn.fnamemodify(current_file, ':h') -- Get the directory of the current file
  require('oil').open(current_dir)
  vim.opt.colorcolumn = ''
end, { desc = 'toggle oil tree' })

-- toggle relative line numbers
vim.keymap.set('n', '<leader>l', function()
  vim.wo.number = true
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { silent = true, desc = 'toggle relative [l]ine numbers' })

-- Command to toggle inline diagnostics
vim.api.nvim_create_user_command('DiagnosticsToggleVirtualText', function()
  local current_value = vim.diagnostic.config().virtual_text
  if current_value then
    vim.diagnostic.config { virtual_text = false }
  else
    vim.diagnostic.config { virtual_text = true }
  end
end, {})

-- toggle diagnostics
vim.keymap.set('n', '<leader>dd', ':DiagnosticsToggle<CR>', { silent = true, desc = 'toggle [d]iagnostics' })

-- Command to toggle diagnostics
vim.api.nvim_create_user_command('DiagnosticsToggle', function()
  local current_value = vim.diagnostic.is_disabled()
  if current_value then
    vim.diagnostic.enable()
  else
    vim.diagnostic.disable()
  end
end, {})

-- toggle line numbers, line indent, and diagnostics
vim.keymap.set('n', '<leader>L', function()
  vim.wo.relativenumber = false -- TODO: if relative line numbers was on then it should be on on retoggle -> global variable
  vim.wo.number = not vim.wo.number
  -- vim.cmd('IndentBlanklineToggle')
  vim.cmd 'Gitsigns toggle_signs'
  vim.cmd 'DiagnosticsToggle'
end, { silent = true, desc = 'hide line numbers' })

-- lazygit
vim.keymap.set('n', 'lg', function()
  vim.cmd 'LazyGit'
end, { desc = 'open LazyGit' })

-- lazygit but with leader
vim.keymap.set('n', '<leader>lg', function()
  vim.cmd 'LazyGit'
end, { desc = 'open LazyGit' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Global variables to track the last buffer and window
_G.python_output_buf = nil
_G.python_output_win = nil

function _G.run_python_on_save()
  -- Get the current file path and escape it properly
  local filepath = vim.fn.shellescape(vim.fn.expand '%:p')

  -- Run the Python file and capture output
  local handle = io.popen('python3 ' .. filepath .. ' 2>&1')
  local result = handle:read '*a'
  handle:close()

  -- Split the output into lines
  local lines = vim.split(result, '\n', { trimempty = true })

  -- Calculate buffer size dynamically
  local max_line_width = 0
  for _, line in ipairs(lines) do
    max_line_width = math.max(max_line_width, #line)
  end

  -- Constrain the buffer dimensions to the output size
  local buf_width = math.min(max_line_width + 2, math.ceil(vim.o.columns * 0.4))
  local buf_height = math.min(#lines + 2, math.ceil(vim.o.lines * 0.3))

  -- Close the previous buffer and window if they exist
  if _G.python_output_buf and vim.api.nvim_buf_is_valid(_G.python_output_buf) then
    vim.api.nvim_buf_delete(_G.python_output_buf, { force = true })
    _G.python_output_buf = nil
  end
  if _G.python_output_win and vim.api.nvim_win_is_valid(_G.python_output_win) then
    vim.api.nvim_win_close(_G.python_output_win, true)
    _G.python_output_win = nil
  end

  -- Create a temporary buffer for output
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  _G.python_output_buf = buf -- Store the new buffer reference

  -- Define border characters similar to Telescope
  local border_chars = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
  -- Enable line wrapping in the buffer
  -- Open the buffer in a floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = buf_width,
    height = buf_height,
    col = vim.o.columns - buf_width - 2, -- Align to the right
    row = 1, -- Position at the top
    style = 'minimal',
    border = border_chars, -- Telescope-style border
  })
  _G.python_output_win = win -- Store the new window reference

  vim.api.nvim_buf_set_option(buf, 'wrap', true)
  -- -- Force focus to the floating window
  -- vim.defer_fn(function()
  --   vim.api.nvim_set_current_win(win)
  -- end, 10) -- Defer the focus slightly to ensure correct behavior

  -- Close the floating buffer with 'q'
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
end

-- Toggle Python run on save
function _G.toggle_python_run_on_save()
  if vim.g.python_autorun_enabled then
    -- Remove the existing autocommand group
    vim.cmd 'autocmd! PythonRunOnSave'
    vim.g.python_autorun_enabled = false
    print 'Python run on save disabled'
  else
    -- Define a new autocommand group
    vim.cmd [[
      augroup PythonRunOnSave
        autocmd!
        autocmd BufWritePost *.py lua _G.run_python_on_save()
      augroup END
    ]]
    vim.g.python_autorun_enabled = true
    print 'Python run on save enabled'
  end
end

-- Map the toggle function to a keymap
vim.api.nvim_set_keymap('n', '<leader>0', '<cmd>lua _G.toggle_python_run_on_save()<CR>', { noremap = true, silent = true })

_G.toggle_autocomplete = function()
  local cmp = require 'cmp'
  autocomplete_enabled = not (autocomplete_enabled or false)
  cmp.setup {
    completion = {
      autocomplete = autocomplete_enabled and { require('cmp.types').cmp.TriggerEvent.TextChanged } or false,
    },
  }
  print('Autocomplete ' .. (autocomplete_enabled and 'Enabled' or 'Disabled'))
end

-- Map the toggle function to <leader>da
vim.api.nvim_set_keymap('n', '<leader>da', ':lua toggle_autocomplete()<CR>', { noremap = true, silent = true })

-- vim: ts=2 sts=2 sw=2 et

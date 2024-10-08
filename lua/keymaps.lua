-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- quick escape
vim.keymap.set('i', 'jk', '<esc>', { desc = 'quick [esc]ape' })
vim.keymap.set('i', 'kj', '<esc>', { desc = 'quick [esc]ape' })

-- beginning and end of line navigation

vim.keymap.set('n', 'H', '^', { desc = 'first character in a line' })
vim.keymap.set('n', 'L', '$', { desc = 'last character in a line' })

-- toggle spell check
-- :set spell – Turn on spell checking
-- :set nospell – Turn off spell checking
vim.keymap.set('n', '<leader>ss', ':set spell!<CR>', { noremap = true, silent = true })
-- ]s – Jump to the next misspelled word
-- [s – Jump to the previous misspelled word
-- z= – Bring up the suggested replacements
-- zg – Good word: Add the word under the cursor to the dictionary
-- zw – Woops! Undo and remove the word from the dictionary

-- remove search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- redo
vim.keymap.set('n', 'U', '<C-r>')

vim.keymap.set('x', '<leader>p', [["_dP]])

-- next with cursor centering
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- page navigation with centering
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- insert line in normal mode
vim.keymap.set('n', '<leader>o', ':normal! o<CR>', { noremap = true, silent = true, desc = 'insert line below' })
vim.keymap.set('n', '<leader>O', ':normal! O<CR>', { noremap = true, silent = true, desc = 'insert line above' })

-- delete after equal sign on line
vim.keymap.set('n', 'd=', '<Esc>:normal! 0f=ld$<CR>a ', { silent = true, desc = 'delete after first equal sign' })

-- change after equal sign on line
vim.keymap.set('n', 'c=', '<Esc>:normal! 0f=ld$<CR>a ', { silent = true, desc = 'change after first equal sign' })

-- substitute word under cursor with confirmation (y/n)
vim.keymap.set('n', '<leader>rc', [[:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>]], { desc = '[R]ename with [C]onfirmation.' })

-- go back to previous buffer
vim.keymap.set('n', '<leader>j', '<C-^>', { desc = 'toggle buffers', silent = true })

-- Diagnostic keymap*
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader><leader>', ':Dashboard<Cr>', { desc = '[ ] Find existing buffers' })
-- vim: ts=2 sts=2 sw=2 et

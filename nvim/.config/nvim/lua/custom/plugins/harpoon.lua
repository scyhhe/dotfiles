return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require('harpoon')
    -- REQUIRED: sets up harpoon's autocmds
    harpoon:setup()
    -- Highlight the current file in the quick menu
    harpoon:extend(require('harpoon.extensions').builtins.highlight_current_file())
  end,
  keys = function()
    local keys = {
      {
        '<leader>ha',
        function()
          require('harpoon'):list():add()
        end,
        desc = 'Harpoon: [a]dd file',
      },
      {
        '<leader>hh',
        function()
          local harpoon = require('harpoon')
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'Harpoon: quick menu',
      },
    }

    for i = 1, 9 do
      table.insert(keys, {
        '<leader>' .. i,
        function()
          require('harpoon'):list():select(i)
        end,
        desc = 'Harpoon to file ' .. i,
      })
    end
    return keys
  end,
}

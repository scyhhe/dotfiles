-- lua/custom/plugins/multicursor.lua
return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    local set = vim.keymap.set

    -- Use case 1: spawn cursor on next/prev occurrence of word under cursor.
    -- <C-n> mirrors IdeaVim / vim-multiple-cursors muscle memory.
    set({ "n", "x" }, "<C-n>", function() mc.matchAddCursor(1) end,  { desc = "Add cursor to next match" })
    set({ "n", "x" }, "<C-p>", function() mc.matchAddCursor(-1) end, { desc = "Add cursor to prev match" })

    -- Skip current match without adding a cursor (like <C-k><C-d> in VS Code)
    set({ "n", "x" }, "<C-x>", function() mc.matchSkipCursor(1) end, { desc = "Skip to next match" })

    -- Select all occurrences at once
    set({ "n", "x" }, "<leader>ma", function() mc.matchAllAddCursors() end, { desc = "Add cursors to all matches" })

    -- Use case 2: spawn cursor on line above/below at same column.
    set({ "n", "x" }, "<C-Up>",   function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })
    set({ "n", "x" }, "<C-Down>", function() mc.lineAddCursor(1) end,  { desc = "Add cursor below" })

    -- Disable/re-enable cursors (keep them but pause editing)
    set({ "n", "x" }, "<leader>mt", mc.toggleCursor, { desc = "Toggle cursor under mouse" })

    -- Esc: clear all extra cursors, or fall through to nohlsearch
    set("n", "<Esc>", function()
      if mc.hasCursors() then
        mc.clearCursors()
      else
        vim.cmd("nohlsearch")
      end
    end)
  end,
}

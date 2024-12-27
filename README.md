# bufclip.nvim

A Neovim plugin for copying buffer contents to clipboard with custom prompts.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "hesiod-au/bufclip.nvim",
    config = function()
        require("bufclip").setup()
    end,
    keys = {
        {
            "<leader>n",
            ":CopyBuffersToClipboard<CR>",
            desc = "Copy buffers to clipboard",
            silent = true
        },
    },
}
```

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
  }
  
  -- tokyo night theme 
  use 'folke/tokyonight.nvim'

  use {
    's1n7ax/nvim-terminal',
    config = function()
        vim.o.hidden = true
        require('nvim-terminal').setup()
    end,
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }


  -- Git related plugins
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  use 'navarasu/onedark.nvim' -- Theme inspired by Atom
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }
  
  -- Nvim dashboard (startup screen) customisation pluggin 
  use 'glepnir/dashboard-nvim'
  use 'nvim-tree/nvim-web-devicons' -- Icons for nvim-tree
  
  -- Coc 
  use {'neoclide/coc.nvim', branch = 'release'}

  -- bar bar for tabline
  use {'romgrk/barbar.nvim', wants = 'nvim-web-devicons'}

  -- NeoTree
  use {
  "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
  }

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme tokyonight-moon]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- setting neovide options (must be done after loading neovide)
vim.cmd [[
  let g:neovide_cursor_vfx_mode = 'railgun'
  let g:neovide_cursor_animation_length = 0.1
  let g:neovide_cursor_trail_length = 0.1
  let g:neovide_cursor_antialiasing = v:true
  let g:neovide_cursor_vfx_particle_lifetime = 0.1
  let g:neovide_cursor_vfx_particle_speed = 1000.0
  let g:neovide_cursor_vfx_particle_density = 1.0
  let g:neovide_cursor_vfx_particle_horiz_mult = 1.0
  let g:neovide_cursor_vfx_particle_vert_mult = 1.0
  let g:neovide_cursor_vfx_mode = 'railgun'
  let g:neovide_cursor_vfx_color = '#ff0000'
  let g:neovide_cursor_vfx_particle_size = 4.0
  let g:neovide_cursor_vfx_enable_shaders = v:true
  let g:neovide_cursor_vfx_enable = v:true
  let g:neovide_cursor_vfx_opacity = 1.0
  let g:neovide_cursor_vfx_particle_drag = 3.0

  let g:neovide_remember_window_size = v:true
  let g:neovide_transparency = 0.9
]]

-- simple stuff in vim
vim.cmd[[
  " set shell=powershell.exe
  set clipboard=unnamedplus

  " cosutmization of the start screen
  let g:dashboard_default_executive = 'telescope'
  let g:dashboard_custom_footer = ['Neovim is the best!']
  
  " coc settings 
  let g:coc_snippet_next = '<c-k>'
  inoremap <silent><expr> <c-space> coc#refresh()

  " toggle neotree (open and close)
  map <leader>nt :NeoTreeShowToggle<CR>
  
  set relativenumber
]]


-- compile and run c++ for competitive programming
vim.cmd[[

" set shellcmdflag=-c

function! TermWrapper(command) abort
	if !exists('g:split_term_style') | let g:split_term_style = 'vertical' | endif
	if g:split_term_style ==# 'vertical'
		let buffercmd = 'vnew'
	elseif g:split_term_style ==# 'horizontal'
		let buffercmd = 'new'
	else
		echoerr 'ERROR! g:split_term_style is not a valid value (must be ''horizontal'' or ''vertical'' but is currently set to ''' . g:split_term_style . ''')'
		throw 'ERROR! g:split_term_style is not a valid value (must be ''horizontal'' or ''vertical'')'
	endif
	exec buffercmd
	if exists('g:split_term_resize_cmd')
		exec g:split_term_resize_cmd
	endif
	exec 'term ' . a:command
	exec 'setlocal nornu nonu'
	exec 'startinsert'
	autocmd BufEnter <buffer> startinsert
endfunction


command! -nargs=0 CompileAndRun call TermWrapper(printf('g++ -o %s %s && %s', expand("%:r"), expand("%"), expand("%:r")))
"autocmd FileType cpp nnoremap <leader>cp :!g++ -o %:r % && %:r<CR>
autocmd FileType cpp nnoremap <leader>cp :CompileAndRun<CR>

]]

-- configuring key mappings for BufferLine plugin 
vim.cmd[[
  nnoremap <silent> <leader>bp :BufferPrevious<CR>
  nnoremap <silent> <leader>bn :BufferNext<CR>
  nnoremap <silent> <leader>bc :BufferClose<CR>
]]






-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'tokyonight',
    --component_separators = '|',
    --section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    space_char_blankline = " ",
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
}


-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  sumneko_lua = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}


-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- configuation of nvim-terminal

-- following option will hide the buffer when it is closed instead of deleting
-- the buffer. This is important to reuse the last terminal buffer
-- IF the option is not set, plugin will open a new terminal every single time
vim.o.hidden = true

require('nvim-terminal').setup({
    window = {
        -- Do `:h :botright` for more information
        -- NOTE: width or height may not be applied in some "pos"
        position = 'botright',

        -- Do `:h split` for more information
        split = 'vsp',

        -- Width of the terminal
        width = 50,

        -- Height of the terminal
        height = 15,
    },

    -- keymap to disable all the default keymaps
    disable_default_keymaps = false,

    -- keymap to toggle open and close terminal window
    toggle_keymap = '<leader>;',

    -- increase the window height by when you hit the keymap
    window_height_change_amount = 2,

    -- increase the window width by when you hit the keymap
    window_width_change_amount = 2,

    -- keymap to increase the window width
    increase_width_keymap = '<leader><leader>+',

    -- keymap to decrease the window width
    decrease_width_keymap = '<leader><leader>-',

    -- keymap to increase the window height
    increase_height_keymap = '<leader>+',

    -- keymap to decrease the window height
    decrease_height_keymap = '<leader>-',

    terminals = {
        -- keymaps to open nth terminal
        {keymap = '<leader>1'},
        {keymap = '<leader>2'},
        {keymap = '<leader>3'},
        {keymap = '<leader>4'},
        {keymap = '<leader>5'},
    },
})


-- customization of the dashboard

local db = require('dashboard')

db.preview_file_height = 12
db.preview_file_width = 80
  db.setup({
    theme = 'doom',
    config = {
      header = {
        -- MOUAD CODER written in ASCII art 
        '',
        '',
        '',
        '',
        '███╗░░░███╗░█████╗░██╗░░░██╗░█████╗░██████╗░  ░█████╗░░█████╗░██████╗░███████╗██████╗░',
        '████╗░████║██╔══██╗██║░░░██║██╔══██╗██╔══██╗  ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗',
        '██╔████╔██║██║░░██║██║░░░██║███████║██║░░██║  ██║░░╚═╝██║░░██║██║░░██║█████╗░░██████╔╝',
        '██║╚██╔╝██║██║░░██║██║░░░██║██╔══██║██║░░██║  ██║░░██╗██║░░██║██║░░██║██╔══╝░░██╔══██╗',
        '██║░╚═╝░██║╚█████╔╝╚██████╔╝██║░░██║██████╔╝  ╚█████╔╝╚█████╔╝██████╔╝███████╗██║░░██║',
        '╚═╝░░░░░╚═╝░╚════╝░░╚═════╝░╚═╝░░╚═╝╚═════╝░  ░╚════╝░░╚════╝░╚═════╝░╚══════╝╚═╝░░╚═╝',
        '',
        '',
        '[ --> Welcome back Mouad <-- ]',
        '',
        '',
        '',
        '',
      },
      center = {
        {
          icon = '  ',
          icon_hi = 'Title',
          desc = 'Find File                             ',
          desc_hi = 'String',
          key = 'f',
          key_hi = 'Number',
          action = 'Telescope find_files',
        },
        {
          icon = '🆕 ',
          icon_hi = 'Title',
          desc = 'Open New Tab                          ',
          desc_hi = 'String',
          key = 't',
          key_hi = 'Number',
          action = 'tabnew',
        },
        {
          icon = '  ',
          icon_hi = 'Title',
          desc = 'Find Word                             ',
          desc_hi = 'String',
          key = 'w',
          key_hi = 'Number',
          action = 'Telescope live_grep'
        },
        {
          icon = '  ',
          desc = 'Find Buffer                           ',
          desc_hi = 'String',
          key = 'b',
          key_hi = 'Number',
          action = 'Telescope buffers'
        }
      },
      footer = {
        '',
        '',
        '',
        '',
        '--> Happy coding! You can make it! <--',
        '',
        '',
        '',

      }
    },
})




-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et


--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.autoformat_enabled = false
vim.g.have_nerd_font = false

-- [[ Setting options ]]

vim.opt.number = true
vim.opt.relativenumber = true
-- creates a backup file
vim.opt.backup = false
vim.opt.swapfile = false
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.breakindent = true
vim.opt.undofile = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'
-- Decrease update time
vim.opt.updatetime = 250
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Configure tabstop
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '_' }
-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
-- Show which line your cursor is on
vim.opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>vv', '<cmd>:vsplit<cr>', { desc = 'Split window' })
-- [[ Basic Autocommands ]]
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
  -- 'tpope/vim-fugitive',
  'rktjmp/lush.nvim', -- required by modern colorschemes
  {
    'sindrets/diffview.nvim',
    config = function()
      vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Git: Diffview Open' })
      vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>', { desc = 'Git: Diffview Open' })
    end,
  },
  { 
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        -- { '<leader>d', group = '[D]ocument' },
        -- { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>v', group = '[V]isits' },
      },
    },
  },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    ft = 'markdown',
    config = function()
      require('markview').setup {
        modes = { 'n', 'i', 'no', 'c' },
        hybrid_modes = { 'n', 'i' },
      }
      vim.cmd 'Markview hybridEnable'
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },
  {
    'freitass/todo.txt-vim',
    opts = {
      todo_done_filename = 'done.txt',
    },                                    
    config = function() end,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      openai = {
        endpoint = 'https://api.openai.com/v1',
        model = 'gpt-4o',
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
        -- ['local'] = false,
      },
      provider = 'openai',
      auto_suggestions_provider = 'openai',
    },
    -- { hints = { enabled = true } },
    build = 'make BUILD_FROM_SOURCE=true',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'echasnovski/mini.icons',
      --- The below dependencies are optional,
      {
        -- Make sure to set this up properly if you have lazy=true
        'OXY2DEV/markview.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = 'markdown',
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('obsidian').setup {
        workspaces = {
          {
            name = 'wiki',
            path = '~/MEGA/vimwiki',
          },
          {
            name = 'zet',
            path = '~/MEGA/zettelkasten',
          },
          {
            name = 'work',
            path = '~/MEGA/dailylogs',
          },
        },
        daily_notes = {
          folder = '~/MEGA/vimwiki/diary',
          date_format = '%Y-%m-%d',
        },
        -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
        -- way then set 'mappings = {}'.
        mappings = {
          -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
          ['gf'] = {
            action = function()
              return require('obsidian').util.gf_passthrough()
            end,
            opts = { noremap = false, expr = true, buffer = true },
          },
          -- Smart action depending on context, either follow link or toggle checkbox.
          ['<ctrl><cr>'] = {
            action = function()
              return require('obsidian').util.smart_action()
            end,
            opts = { buffer = true, expr = true },
          },
        },
        picker = {
          -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
          name = 'fzf-lua',
          -- Optional, configure key mappings for the picker. These are the defaults.
          -- Not all pickers support all mappings.
          note_mappings = {
            -- Create a new note from your query.
            new = '<C-x>',
            -- Insert a link to the selected note.
            insert_link = '<C-l>',
          },
          tag_mappings = {
            -- Add tag(s) to current note.
            tag_note = '<C-x>',
            -- Insert a tag at the current location.
            insert_tag = '<C-l>',
          },
        },

        -- Optional, for templates (see below).
        -- templates = {
        --     subdir = "~/MEGA/dailylogs/templates",
        --     date_format = "%Y-%m-%d",
        --     time_format = "%H:%M",
        --     -- A map for custom variables, the key should be the variable and the value a function
        --     substitutions = {},
        -- },
        -- see below for full list of options 👇
      }
    end,
  },                                   
  {
    'ibhagwan/fzf-lua',
    config = function()
      require('fzf-lua').setup {
        fzf_colors = true,
      }
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { desc = 'FZF: ' .. desc })
      end

      map('<leader><leader>', '<cmd>FzfLua git_files<cr>', 'Files')
      map('<leader>/', '<cmd>FzfLua live_grep<cr>', 'Grep')
      map('<leader>fr', '<cmd>FzfLua oldfiles<cr>', 'Oldfiles')
      map('<leader>fb', '<cmd>FzfLua buffers<cr>', 'Buffers')
      map('<leader>ft', '<cmd>FzfLua tabs<cr>', 'Tabs')
      map('<leader>R', '<cmd>FzfLua resume<cr>', 'Resume')
      map('<leader>zc', '<cmd>FzfLua colorschemes<cr>', 'Colors')
      map('<leader>zm', '<cmd>FzfLua marks<cr>', 'Marks')
      map('<leader>zq', '<cmd>FzfLua quickfix<cr>', 'Quickfix')
      map('<leader>zl', '<cmd>FzfLua loclist<cr>', 'Loclist')
      map('<leader>zr', '<cmd>FzfLua registers<cr>', 'Registers')
    end,
  },
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', '<cmd>FzfLua lsp_definitions jump_to_single_result=true ignore_current_line=true<cr>', '[G]oto [D]efinition')
          map('gr', '<cmd>FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<cr>', '[G]oto [R]ferences')
          map('gI', '<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>', '[G]oto [I]mplementation')
          map('gy', '<cmd>FzfLua lsp_typedefs jump_to_single_result=true ignore_current_line=true<cr>', 'T[y]pe Definition')
          map('<leader>cs', '<cmd>FzfLua lsp_document_symbols<cr>', '[C]ode [S]ymbols')
          map('<leader>cd', '<cmd>FzfLua lsp_document_diagnostics<cr>', '[C]ode [D]iagnostics', { 'n', 'x' })
          vim.bo[event.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
          -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          local is_v11 = vim.fn.has('nvim-0.11') == 1

          -- enable completion side effects (if possible)
          -- note is only available in neovim v0.11 or greater
          if is_v11 and client and client.supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client_id, event.buf, {})
          end
        end,
      })
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local servers = {
        intelephense = {
          settings = {
            intelephense = {
              format = {
                enable = false,
              },
            },
          },
        },
        marksman = {},
        deno = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { "miikanissi/modus-themes.nvim", priority = 1000 },
  { "projekt0n/github-nvim-theme", priority = 1000 },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    requires = {},
    priority = 1000,
    init = function()
      vim.opt.background = 'light'
      vim.cmd.colorscheme 'github_light_tritanopia'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=italic'
      vim.cmd.hi 'Keyword gui=bold'
    end,
  },
  {
    'MagicDuck/grug-far.nvim',
    opts = { headerMaxWidth = 80 },
    cmd = 'GrugFar',
    keys = {
      {
        '<leader>H',
        function()
          local grug = require 'grug-far'
          local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
            },
          }
        end,
        mode = { 'n', 'v' },
        desc = 'Search and Replace',
      },
    },
  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup {
        n_lines = 500,
        -- doesn't work for me. Need to investigate
        custom_textobjects = {
          o = require('mini.ai').gen_spec.treesitter { -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          },
          f = require('mini.ai').gen_spec.treesitter { a = '@function.outer', i = '@function.inner' }, -- function
          c = require('mini.ai').gen_spec.treesitter { a = '@class.outer', i = '@class.inner' }, -- class
        },
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      require('mini.align').setup()
      require('mini.animate').setup()
      require('mini.notify').setup()
      require('mini.tabline').setup()
      require('mini.visits').setup()

      local mini_statusline = require 'mini.statusline'
      local function statusline()
        local mode, mode_hl = mini_statusline.section_mode({trunc_width = 120})
        local git = mini_statusline.section_git({})
        local diff = mini_statusline.section_diff({})
        local diagnostics = mini_statusline.section_diagnostics({trunc_width = 75})
        local search = mini_statusline.section_searchcount({})
        local lsp = mini_statusline.section_lsp({icon = 'λ', trunc_width = 75})
        local filename = mini_statusline.section_filename({trunc_width = 140})
        local percent = '%2p%%'
        local location = '%3l:%-2c'

        return mini_statusline.combine_groups({
          {hl = mode_hl,                  strings = {mode}},
          {hl = 'MiniStatuslineDevinfo',  strings = {git}},
          '%<', -- Mark general truncate point
          {hl = 'MiniStatuslineFilename', strings = {filename, search}},
          '%=', -- End left alignment
          {hl = 'MiniStatuslineFilename', strings = {'%{&filetype}'}},
          {hl = 'MiniStatuslineFileinfo', strings = {percent}},
          {hl = mode_hl,                  strings = {location}},
        })
      end

      mini_statusline.setup({
        content = {active = statusline},
      })


      require('mini.notify').setup({
        lsp_progress = {enable = false},
      })
      vim.notify = require('mini.notify').make_notify({})

      require('mini.bufremove').setup({})
      require('mini.visits').setup({})

      -- Create and select
      local map_vis = function(keys, call, desc)
        local rhs = '<Cmd>lua MiniVisits.' .. call .. '<CR>'
        vim.keymap.set('n', '<Leader>' .. keys, rhs, { desc = desc })
      end

      map_vis('vc', 'add_label("core")',                     'Add to core')
      map_vis('vC', 'remove_label("core")',                  'Remove from core')
      map_vis('vv', 'select_path("", {})',  'Select (all)')
      map_vis('vV', 'select_path(nil, {})', 'Select (cwd)')
      map_vis('vg', 'select_path("", { filter = "core" })',  'Select core (all)')
      map_vis('vG', 'select_path(nil, { filter = "core" })', 'Select core (cwd)')

      local map_branch = function(keys, action, desc)
        local rhs = function()
          local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD')
          if vim.v.shell_error ~= 0 then return nil end
          branch = vim.trim(branch)
          require('mini.visits')[action](branch)
        end
        vim.keymap.set('n', '<Leader>' .. keys, rhs, { desc = desc })
      end

      map_branch('vb', 'add_label',    'Add branch label')
      map_branch('vB', 'remove_label', 'Remove branch label')
      -- Iterate based on recency
      local map_iterate_core = function(lhs, direction, desc)
        local opts = { filter = 'core', sort = sort_latest, wrap = true }
        local rhs = function()
          MiniVisits.iterate_paths(direction, vim.fn.getcwd(), opts)
        end
        vim.keymap.set('n', lhs, rhs, { desc = desc })
      end

      map_iterate_core('[{', 'last',     'Core label (earliest)')
      map_iterate_core('[[', 'forward',  'Core label (earlier)')
      map_iterate_core(']]', 'backward', 'Core label (later)')
      map_iterate_core(']}', 'first',    'Core label (latest)')

      -- Get paths from all cwd sorted from most to least frequent
      local sort_frequent = MiniVisits.gen_sort.default({ recency_weight = 0 })
      vim.keymap.set('n', '<leader>vf', "<cmd> lua MiniVisits.list_paths('', { sort = sort_frequent })<cr>", {desc = 'List visits'})
      -- Close buffer and preserve window layout
      vim.keymap.set('n', '<leader>bd', '<cmd>lua pcall(MiniBufremove.delete)<cr>', {desc = 'Close buffer'})

      require('mini.hipatterns').setup {
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          -- Highlight hex color strings (`#rrggbb`) using that color
          -- hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }
      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
      require('mini.icons').setup()
      require('mini.colors').setup()
      require('mini.completion').setup {
        lsp_completion = {
          source_func = 'omnifunc',
          auto_setup = false,
        },
      }
      require('mini.files').setup()
      vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open()<cr>', { desc = 'Explorer' })
      require('mini.bracketed').setup()
      require('mini.diff').setup()
      require('mini.git').setup()

      --- align gitblame to right
      local align_blame = function(au_data)
        if au_data.data.git_subcommand ~= 'blame' then
          return
        end

        -- Align blame output with source
        local win_src = au_data.data.win_source
        vim.wo.wrap = false
        vim.fn.winrestview { topline = vim.fn.line('w0', win_src) }
        vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', win_src), 0 })

        -- Bind both windows so that they scroll together
        vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
      end

      local au_opts = { pattern = 'MiniGitCommandSplit', callback = align_blame }
      vim.api.nvim_create_autocmd('User', au_opts)

      vim.keymap.set({ 'n', 'x' }, '<Leader>gh', '<Cmd>lua MiniGit.show_at_cursor()<cr>', { desc = 'Git: Show history at cursor' })
      vim.keymap.set({ 'n', 'x' }, '<leader>gc', '<cmd>lua MiniDiff.toggle_overlay()<cr>', { desc = 'Git: Compare changes on cursor' })
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'php', 'javascript', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'php' },
      },
      indent = { enable = false, disable = { 'php' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    textobjects = {
      move = {
        enable = true,
        goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
        goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
        goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
        goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
      },
    },
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Function to upload a file via scp
local function upload_file_via_scp(filepath, remote_path, server)
  -- Construct the scp command
  local scp_command = string.format('scp %s %s:%s', filepath, server, remote_path)

  -- Execute the scp command
  local success = os.execute(scp_command)

  -- Notify the user about the result
  if success == 0 then
    vim.notify('File uploaded successfully!', vim.log.levels.INFO)
  else
    vim.notify('File upload failed!', vim.log.levels.ERROR)
  end
end

-- Set up an autocommand for file save
local function setup_autosave_scp(local_folder, remote_folder, server)
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('AutoSCPUpload', { clear = true }),
    callback = function(args)
      -- Get the file path of the saved file
      local fullfilepath = vim.fn.fnamemodify(vim.fn.expand(args.file), ':p')

      -- Check if the file is in the specified local folder
      if fullfilepath:find(local_folder, 1, true) then
        -- Extract the relative path of the file within the local folder
        local relative_path = fullfilepath:sub(#local_folder + 2)

        -- Construct the remote path
        local remote_path = remote_folder .. '/' .. relative_path

        -- Trigger the scp upload
        upload_file_via_scp(fullfilepath, remote_path, server)
      end
    end,
  })
end

-- Example usage: Configure the folder and server
setup_autosave_scp(
  '/home/marius/Projects/aynax', -- Local folder to monitor
  '/home/marius/aynax', -- Remote server folder
  'a4' -- Remote server (e.g., user@host)
)

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'php',
  callback = function()
    vim.b.autoformat = false
    vim.keymap.set({'i'}, '<leader>,v', 'var_dump();<esc>2ha',{desc="var_dump()"});
    vim.keymap.set({'i'}, '<leader>,d', 'var_dump();die;<esc>5hi',{desc="var_dump();die"});
    vim.keymap.set({'i'}, '<leader>,b', 'Tracy\\Debugger::bdump();<esc>2ha',{desc="Debugger::bdump()"});
    vim.keymap.set({'n'}, '<leader>,v', 'ivar_dump();<esc>2ha',{desc="var_dump()"});
    vim.keymap.set({'n'}, '<leader>,d', 'ivar_dump();die;<esc>5hi',{desc="var_dump();die"});
    vim.keymap.set({'n'}, '<leader>,b', 'iTracy\\Debugger::bdump();<esc>2ha',{desc="Debugger::bdump()"});
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

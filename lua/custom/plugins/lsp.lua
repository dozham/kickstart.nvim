return {
  -- Java LSP Setup
  {
    'mfussenegger/nvim-jdtls',
    -- Only load this plugin when opening a Java file
    ft = 'java',
    config = function()
      -- nvim-jdtls is not a standard lspconfig server. It needs to be attached
      -- per-buffer when a Java file is opened. We use an autocmd for this.
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function()
          local config = {
            cmd = {
              'jdtls',
              -- prevent .settings, .project, etc files from being generated in the project folder
              '--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false',
              '-Xmx8G',
            },
            -- Find the root directory of the Java project
            root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]) or vim.fn.getcwd(),
            settings = {
              java = {
                format = {
                  enabled = true,
                  comments = { enabled = false },
                  tabSize = 4,
                },
              },
            },
          }
          
          require('jdtls').start_or_attach(config)
        end,
      })
    end,
  },
}
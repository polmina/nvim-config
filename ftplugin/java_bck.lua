local home = os.getenv "HOME"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local bundles = {
  vim.fn.glob("/home/marc/.config/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
};
vim.list_extend(bundles, vim.split(vim.fn.glob("/home/marc/.config/nvim/vscode-java-test/server/*.jar"), "\n"))

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:/home/marc/.config/nvim/java/lombok.jar',
    '-Xms1g',
    '-jar', vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration', home .. "/.local/share/nvim/mason/packages/jdtls/config_linux",
    '-data', home .. '/workspace/' .. project_name,
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
  },
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },
  init_options = {
    bundles = bundles,
    jvm_args = {
        "-Xbootclasspath/a:~/.config/nvim/java/lombok.jar"
    }
  },
}

require('jdtls').start_or_attach(config)

vim.keymap.set("n", "<A-o>", function()
    require("jdtls").organize_imports()
end, { desc = "Organize imports" })
vim.keymap.set("n", "eev", function()
    require("jdtls").extract_variable()
end, { desc = "Extract variable" })
vim.keymap.set("v", "eev", function()
    require("jdtls").extract_variable(true)
end, { desc = "Extract variable(true)" })
vim.keymap.set("n", "eec", function()
    require("jdtls").extract_constant()
end, { desc = "Extract constant" })
vim.keymap.set("v", "eec", function()
    require("jdtls").extract_constant(true)
end, { desc = "Extract constant(true)" })
vim.keymap.set("v", "eem", function()
    require("jdtls").extract_method(true)
end, { desc = "Extract method(true)" })
vim.keymap.set("n", "<leader>ss", "aSystem.out.println()<Esc>i", { desc = "Sout shortand" })
vim.keymap.set("n", "<leader>p", ":e src/main/resources/application.properties<CR>", { desc = "Edit application.properties" })

-- vim.keymap.set('n', ':w', ':silent !java -jar /home/marc/.config/nvim/java/google-java-format-1.15.0.jar --replace %<CR>', { desc = "Format on save" })

-- If using nvim-dap
-- This requires java-debug and vscode-java-test bundles, see install steps in this README further below.
-- nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
-- nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>


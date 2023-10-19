local jdtls = require("jdtls")
-- local on_attach = require("cmp_nvim_lsp").on_attach -- change to yours

local root_dir = require("jdtls.setup").find_root({ "packageInfo", ".git", "gradlew" }, "Config")
local home = os.getenv("HOME")
local eclipse_workspace = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- append_to_file("root_dir:")
-- append_to_file(root_dir)

local bundles = {
  -- vim.fn.glob("/home/marc/.config/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
};
-- vim.list_extend(bundles, vim.split(vim.fn.glob("/home/marc/.config/nvim/vscode-java-test/server/*.jar"), "\n"))

local ws_folders_jdtls = {}
if root_dir then
    local file = io.open(root_dir .. "/.bemol/ws_root_folders")
    if file then
        -- append_to_file("apparently there is file")
        for line in file:lines() do
            -- append_to_file("found line:")
            -- append_to_file(line)
            table.insert(ws_folders_jdtls, "file://" .. line)
        end
        file:close()
    end
end

local config = {
    on_attach = on_attach,
    cmd = {
        "jdtls", -- need to be on your PATH
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        "--jvm-arg=-javaagent:" .. home .. "/.config/nvim/java/lombok.jar", -- need for lombok magic
        '-Xms1g',
        "-jar", vim.fn.glob(home .. "/.config/nvim/java/jdt-language-server-1.17.0/plugins/org.eclipse.equinox.launcher_*.jar"),
        '-configuration', home .. "/.config/nvim/java/jdt-language-server-1.17.0/config_mac",
        "-data", eclipse_workspace,
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    },
    root_dir = root_dir,
    init_options = {
        workspaceFolders = ws_folders_jdtls,
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


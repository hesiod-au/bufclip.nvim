local M = {}

M.custom_prompt = [[
Here is the content of one or more files. 
Files will begin with a line that specifies the filename preceded by ## 
Each file should be written into a separate artifact. 
The artifact label should be the relative filename. 
The first line of the artifact content should include the file path as a language specific comment on the first line of the file using the following format: @@filename: <file_path>
Replace <file_path> with the actual file path relative to the project's root directory. For example:
// @@filename: src/components/Header.tsx.
Follow this pattern for any subsequent artifact creation also.
]]

M.avante_prompt = [[
Here is the content of one or more files from the same project as the content of the file to be edited. 
These additional files will begin with a line that specifies the filename preceded by ## 
Use these files for reference only and return code to edit from the main file only.
]]

function M.copy_buffers_to_clipboard(avante)
	local buffers = vim.api.nvim_list_bufs()
	local result = {}
	local resultAvante = {}

	-- Format the custom prompt with current date and Neovim version
	local formatted_prompt = string.format(
		M.custom_prompt,
		os.date("%Y-%m-%d %H:%M:%S"),
		vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
	)
	table.insert(result, formatted_prompt)

	table.insert(resultAvante, M.avante_prompt)

	local allbufs = {}

	for _, bufnr in ipairs(buffers) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			local relative_path = vim.fn.fnamemodify(bufname, ":.")
			local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			if #lines > 0 then
				table.insert(allbufs, "## " .. relative_path)
				table.insert(allbufs, "")
				for _, line in ipairs(lines) do
					table.insert(allbufs, line)
				end
				table.insert(allbufs, "")
				table.insert(allbufs, "---")
				table.insert(allbufs, "")
			end
		end
	end
	local bufferc = table.concat(allbufs, "\n")
	table.insert(result, bufferc)
	table.insert(resultAvante, bufferc)

	local content = table.concat(result, "\n")
	local contentAvante = table.concat(resultAvante, "\n")

	if avante then
		vim.fn.setreg("+", contentAvante)
	else
		vim.fn.setreg("+", content)
	end
	print("Buffer contents copied to clipboard.")
end
function M.setup()
	vim.api.nvim_create_user_command("CopyBuffersToClipboard", function()
		M.copy_buffers_to_clipboard(false)
	end, {})
	vim.api.nvim_create_user_command("CopyBuffersToClipboardAvante", function()
		M.copy_buffers_to_clipboard(true)
	end, {})
end

return M

local M = {}

function M.yaml_ft(path, bufnr)
  local buf_text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
  if vim.regex("(tasks\\|roles\\|handlers)/"):match_str(path) or vim.regex("hosts:\\|tasks:"):match_str(buf_text) then
    return "yaml.ansible"
  elseif vim.regex("AWSTemplateFormatVersion:"):match_str(buf_text) then
    return "yaml.cfn"
  else
    return "yaml"
  end
end

return M

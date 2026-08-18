-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = "Batman"
config.default_cursor_style = 'BlinkingUnderline'
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19

-- Force the tab bar to always show, even with only 1 tab open
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

-- Optional: Use the sleek, modern native window bar tabs instead of a retro bar
config.use_fancy_tab_bar = true 
config.window_close_confirmation = 'NeverPrompt'
config.show_tab_index_in_tab_bar = false

-- Function to extract only the last folder name (like 'project' instead of '/home/user/project')
local function get_cwd_basename(tab_info)
  local cwd = tab_info.active_pane.current_working_dir
  if cwd then
    -- Convert URL object or string path to a clean string
    local path = type(cwd) == 'table' and cwd.file_path or tostring(cwd)
    -- Strip trailing slash if present
    path = path:gsub('[/\\]$', '')
    -- Match everything after the final slash
    local basename = path:match('([^/\\]+)$')
    return basename or path
  end
  -- Fallback to pane title if CWD is not reported yet
  return tab_info.active_pane.title
end

-- Hook into the tab formatting lifecycle (Only define this ONCE)
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  -- 1. Check if you set a manual title via a prompt. If not, use the current folder name.
  local title = tab.tab_title
  if not title or #title == 0 then
    title = get_cwd_basename(tab)
  end

  -- 2. Style the active tab differently from inactive tabs
  if tab.is_active then
    return {
      { Background = { Color = '#282c34' } }, -- Dark gray background
      { Foreground = { Color = '#61afef' } }, -- Cool blue text
      { Text = '  ' .. title .. '  ' },
    }
  end
  return {
    { Text = '  ' .. title .. '  ' },
  }
end)

-- config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

-- my coolnight colorscheme:
config.colors = {
	foreground = "#CBE0F0",
	-- background = "#011423",
  background = "#23252e",
  --  background = "#000",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

-- and finally, return the configuration to wezterm
return config

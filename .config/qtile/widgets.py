# Justine Smithies
# https://github.com/justinesmithies/qtile-wayland-dotfiles

# Widgets setup
# Get the icons at https://www.nerdfonts.com/cheat-sheet

import os
import subprocess
from libqtile import qtile
from libqtile import widget
from colors import *
from ordinaldate import custom_date
from keys import terminal


widget_defaults = dict(
    font='FiraCode Nerd Font Regular',
    fontsize='12',
    padding=2,
)
extension_defaults = widget_defaults.copy()

primary_widgets = [
    widget.Spacer(length=10),
    widget.GroupBox(
        borderwidth=2,
        inactive='969696',
        this_current_screen_border='eee8d5',
        this_screen_border='eee8d5',
        font='FiraCode Nerd Font',
        fontsize=14,
        highlight_method='line',
        highlight_color=['00000000', '00000000']
    ),
    widget.CurrentLayoutIcon(scale=0.7),
    widget.CurrentLayout(**widget_defaults),
    widget.Spacer(length=320),
    widget.GenPollText(
        func=custom_date,
        update_interval=1,
        **widget_defaults,
        mouse_callbacks={
            'Button1': lambda: qtile.cmd_spawn(os.path.expanduser("~/.local/bin/statusbar/calendar.sh show"), shell=True),
            'Button3': lambda: qtile.cmd_spawn(os.path.expanduser("~/.local/bin/statusbar/calendar.sh edit"), shell=True)
        }
    ),
    widget.Spacer(),
    widget.CheckUpdates(
        **widget_defaults,
        update_interval=600,
        distro='Arch_paru',
        custom_command='~/.local/bin/statusbar/arch-updates.sh',
        display_format=' {updates}',
        colour_have_updates=colors[2],
        execute='kitty -e paru'
    ),
    widget.Spacer(length=5),
    widget.KeyboardLayout(configured_keyboards=['us', 'gb']),
    widget.Spacer(length=5),
    widget.GenPollText(update_interval=1, **widget_defaults, func=lambda: subprocess.check_output(os.path.expanduser("~/.local/bin/statusbar/brightnesscontrol")).decode(), mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(os.path.expanduser("~/.local/bin/statusbar/brightnesscontrol down"), shell=True), 'Button3': lambda: qtile.cmd_spawn(os.path.expanduser("~/.local/bin/statusbar/brightnesscontrol up"), shell=True)}),
    widget.Spacer(length=5),
    widget.GenPollText(update_interval=1, **widget_defaults, func=lambda: subprocess.check_output(os.path.expanduser("~/.local/bin/statusbar/volumecontrol")).decode(), mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(os.path.expanduser("~/.local/bin/statusbar/volumecontrol down"), shell=True), 'Button2': lambda: qtile.cmd_spawn(os.path.expanduser("~/.local/bin/statusbar/volumecontrol mute"), shell=True), 'Button3': lambda: qtile.cmd_spawn(os.path.expanduser("~/.local/bin/statusbar/volumecontrol up"), shell=True)}),
    widget.Spacer(length=5),
    widget.GenPollText(update_interval=1, **widget_defaults, func=lambda: subprocess.check_output(os.path.expanduser("~/.local/bin/statusbar/battery.py")).decode(), mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(os.path.expanduser("~/.local/bin/statusbar/battery.py --c left-click"), shell=True)}),
    widget.Spacer(length=5),
    widget.GenPollText(update_interval=1, **widget_defaults, func=lambda: subprocess.check_output(os.path.expanduser("~/.local/bin/statusbar/network.sh")).decode(), mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(os.path.expanduser("~/.local/bin/statusbar/network.sh ShowInfo"), shell=True), 'Button3': lambda: qtile.cmd_spawn(terminal + ' -e nmtui', shell=True)}),
    widget.Spacer(length=10),
]

secondary_widgets = [
    widget.GroupBox(
        borderwidth=2,
        inactive='969696',
        this_current_screen_border='eee8d5',
        this_screen_border='eee8d5',
        font='FiraCode Nerd Font',
        fontsize=14, highlight_method='line',
        highlight_color=['00000000', '00000000']
    ),
    widget.CurrentLayoutIcon(scale=0.7),
    widget.CurrentLayout(**widget_defaults),
    widget.Spacer(length=320),
    widget.GenPollText(
        func=custom_date,
        update_interval=1,
        **widget_defaults,
        mouse_callbacks={
            'Button1': lambda: qtile.cmd_spawn(os.path.expanduser("~/.local/bin/statusbar/calendar.sh show"), shell=True),
            'Button3': lambda: qtile.cmd_spawn(os.path.expanduser("~/.local/bin/statusbar/calendar.sh edit"), shell=True)
        }
    ),
    widget.Spacer(),
]

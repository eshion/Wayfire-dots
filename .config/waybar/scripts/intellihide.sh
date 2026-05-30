#!/bin/bash

# 初始化状态标志 (0 为显示，1 为隐藏)
DOCK_HIDDEN=0

# 监听 Wayfire 的视图状态改变
wayfire-msg watch-views | while read -r line; do
    # 检查当前处于激活且最大化的窗口数量
    IS_MAXIMIZED=$(wayfire-msg list-views | jq '[.[] | select(."activated" == true and ."maximized" == true)] | length')

    if [ "$IS_MAXIMIZED" -gt 0 ]; then
        # 检测到窗口最大化时
        if [ "$DOCK_HIDDEN" -eq 0 ]; then
            # 精准对名为 bottom_dock 的实例发送隐藏信号
            waybar -toggle bottom_dock 2>/dev/null || pkill -USR1 -f "bottom_dock"
            DOCK_HIDDEN=1
        fi
    else
        # 窗口恢复常规大小或回到桌面
        if [ "$DOCK_HIDDEN" -eq 1 ]; then
            # 重新唤醒底部的 dock
            waybar -toggle bottom_dock 2>/dev/null || pkill -USR1 -f "bottom_dock"
            DOCK_HIDDEN=0
        fi
    fi
done

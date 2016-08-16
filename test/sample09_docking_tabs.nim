import sample_registry

import nimx.view, nimx.linear_layout, nimx.button
import nimx.editor.tab_view

import random

type DockingTabsSampleView = ref object of View

var gTabIndex = 0
proc newTabTitle(): string =
    inc gTabIndex
    result = "Tab " & $gTabIndex

proc newRandomColor(): Color = newColor(random(1.0), random(1.0), random(1.0), 1.0)

proc newTab(): View =
    result = View.new(newRect(0, 0, 100, 100))
    result.backgroundColor = newRandomColor()

    const buttonSize = 20
    let pane = result

    proc indexOfPaneInTabView(): int =
        let tv = TabView(pane.superview)
        for i in 0 ..< tv.tabsCount:
            if tv.viewOfTab(i) == pane:
                return i
        result = -1

    let addButton = Button.new(newRect(5, 5, buttonSize, buttonSize))
    addButton.title = "+"
    addButton.onAction do():
        let tv = TabView(pane.superview)
        let i = indexOfPaneInTabView() + 1
        tv.insertTab(i, newTabTitle(), newTab())
        tv.selectTab(i)
    result.addSubview(addButton)

    let removeButton = Button.new(newRect(addButton.frame.maxX + 2, 5, buttonSize, buttonSize))
    removeButton.title = "-"
    removeButton.onAction do():
        let tv = TabView(pane.superview)
        if tv.tabsCount == 1:
            var s = pane.superview
            while not s.isNil and s.superview of LinearLayout and s.superview.subviews.len == 1:
                s = s.superview
            s.removeFromSuperview()
        else:
            tv.removeTab(indexOfPaneInTabView())
    result.addSubview(removeButton)

    let c = Button.new(newRect(removeButton.frame.maxX + 2, 5, buttonSize, buttonSize))
    c.title = "c"
    c.onAction do():
        pane.backgroundColor = newRandomColor()
    result.addSubview(c)

method init(v: DockingTabsSampleView, r: Rect) =
    procCall v.View.init(r)
    let pane = TabView.new(v.bounds)
    pane.dockingTabs = true
    pane.addTab(newTabTitle(), newTab())
    pane.autoresizingMask = {afFlexibleWidth, afFlexibleHeight}
    v.addSubview(pane)

registerSample(DockingTabsSampleView, "Docking Tabs")

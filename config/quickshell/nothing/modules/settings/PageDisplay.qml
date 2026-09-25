import QtQuick
import qs.services
import qs.components

Page {
    title: "Display"
    subtitle: "Resolution and scale changes revert after 12 seconds unless you keep them."

    // Confirm banner for pending monitor changes
    Rectangle {
        visible: HyprConf.pendingMonitor !== null
        width: parent.width
        height: 64
        radius: Theme.radius
        color: Theme.accent
        Label {
            x: 22
            anchors.verticalCenter: parent.verticalCenter
            text: "Keep these display settings?"
            color: Theme.accentFg
            font.pixelSize: 13
        }
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8
            OptButton { text: "Revert"; onClicked: HyprConf.revertMonitor() }
            OptButton { text: "Keep"; accent: false; onClicked: HyprConf.keepMonitor() }
        }
    }

    Repeater {
        model: HyprConf.monitors
        Section {
            id: mon
            required property var modelData
            title: modelData.name + " · " + (modelData.make || "") + " " + (modelData.model || "")
            OptChoice {
                label: "Resolution"
                sub: mon.modelData.width + " × " + mon.modelData.height + " @ " + mon.modelData.refreshRate.toFixed(2) + " Hz"
                options: (mon.modelData.availableModes ?? []).slice(0, 5).map(m => ({ label: m.replace("Hz", ""), value: m.replace("Hz", "") }))
                current: mon.modelData.width + "x" + mon.modelData.height + "@" + mon.modelData.refreshRate.toFixed(2)
                onPicked: v => HyprConf.setMonitor(mon.modelData.name, { mode: v })
            }
            OptChoice {
                label: "Scale"
                options: [1, 1.25, 1.5, 1.6, 2].map(s => ({ label: s + "×", value: s }))
                current: mon.modelData.scale
                onPicked: v => HyprConf.setMonitor(mon.modelData.name, { scale: v })
            }
            OptRow {
                label: "Position"
                sub: "Set in nwg-displays or HyprMod for multi-monitor layouts"
                Caption { text: mon.modelData.x + ", " + mon.modelData.y; color: Theme.fg }
            }
        }
    }

    Section {
        title: "Picture"
        OptSlider {
            visible: Brightness.available
            label: "Brightness"
            from: 1
            to: 100
            suffix: "%"
            value: Math.round(Brightness.value * 100)
            onCommitted: v => Brightness.set(v / 100)
        }
        OptSwitch {
            label: "Night light"
            sub: "Warmer colours via hyprsunset"
            checked: Toggles.nightLight
            onToggled: on => Toggles.setNightLight(on)
        }
        OptSlider {
            label: "Night light warmth"
            from: 2500
            to: 6000
            step: 100
            suffix: " K"
            value: Config.nightTemp
            onCommitted: v => {
                Config.set("nightLight.temperature", Math.round(v));
                if (Toggles.nightLight)
                    applyLater.restart();
            }
            Timer { id: applyLater; interval: 200; onTriggered: Toggles.applyNightLight() }
        }
    }

    Section {
        title: "Refresh & power"
        HChoice {
            label: "Variable refresh rate"
            key: "misc:vrr"
            options: [{ label: "Off", value: 0 }, { label: "On", value: 1 }, { label: "Fullscreen", value: 2 }]
        }
        HSwitch { label: "Wake on mouse move"; key: "misc:mouse_move_enables_dpms" }
        HSwitch { label: "Wake on key press"; key: "misc:key_press_enables_dpms" }
        HSwitch { label: "XWayland zero scaling"; sub: "Sharper X11 apps on scaled displays"; key: "xwayland:force_zero_scaling" }
    }
}

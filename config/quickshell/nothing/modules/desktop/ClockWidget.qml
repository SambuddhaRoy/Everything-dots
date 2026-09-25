import QtQuick
import Quickshell
import qs.services
import qs.components

// Big dot-matrix time with a serif date, straight on the wallpaper.
Column {
    id: root
    spacing: 14

    function isoWeek(d) {
        const t = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
        t.setUTCDate(t.getUTCDate() + 4 - (t.getUTCDay() || 7));
        return Math.ceil(((t - new Date(Date.UTC(t.getUTCFullYear(), 0, 1))) / 86400000 + 1) / 7);
    }

    SystemClock {
        id: time
        precision: SystemClock.Minutes
    }
    DotText {
        text: Qt.formatDateTime(time.date, Config.get("pill.clock24h") ? "hh:mm" : "h:mm")
        dot: 9
        gap: 3.4
        offOpacity: 0.08
    }
    Heading {
        text: Qt.formatDateTime(time.date, "dddd, d MMMM")
        font.pixelSize: 46
    }
    Caption {
        text: "Week " + root.isoWeek(time.date) + " · " + (Forecast.location || Quickshell.env("USER"))
        font.pixelSize: 12
        color: Theme.fg
        opacity: 0.8
    }
}

// Пример: Круговая диаграмма (ручная реализация на CeTZ)
#set page(width: auto, height: auto, margin: 1.5em)
#set text(font: "Liberation Serif", size: 12pt)

#import "@preview/cetz:0.4.2"

#cetz.canvas({
  import cetz.draw: *

  let data = (
    ("Docker", 35, rgb("#2563EB")),
    ("Kubernetes", 25, rgb("#7C3AED")),
    ("Podman", 15, rgb("#DC2626")),
    ("containerd", 12, rgb("#EA580C")),
    ("LXC/LXD", 8, rgb("#16A34A")),
    ("Другое", 5, rgb("#94A3B8")),
  )

  let total = data.fold(0, (acc, d) => acc + d.at(1))
  let radius = 3.5
  let label-r = 4.5
  let center = (0, 0)

  let start = 0

  for (name, value, color) in data {
    let angle = value / total * 360
    let end = start + angle
    let mid = start + angle / 2

    // Сектор
    let steps = calc.max(2, int(angle / 5))
    let points = (center,)
    let i = 0
    while i <= steps {
      let a = (start + angle * i / steps) * calc.pi / 180
      points.push((radius * calc.cos(a), radius * calc.sin(a)))
      i += 1
    }

    line(..points, close: true, fill: color, stroke: 1pt + white)

    // Подпись снаружи
    let mid-rad = mid * calc.pi / 180
    let lx = label-r * calc.cos(mid-rad)
    let ly = label-r * calc.sin(mid-rad)
    let pct = calc.round(value / total * 100, digits: 0)

    let anchor = if lx < 0 { "east" } else { "west" }
    content(
      (lx, ly),
      text(size: 10pt)[#name (#pct%)],
      anchor: anchor,
    )

    // Линия-выноска
    let inner-x = (radius + 0.15) * calc.cos(mid-rad)
    let inner-y = (radius + 0.15) * calc.sin(mid-rad)
    let outer-x = (label-r - 0.3) * calc.cos(mid-rad)
    let outer-y = (label-r - 0.3) * calc.sin(mid-rad)
    line(
      (inner-x, inner-y),
      (outer-x, outer-y),
      stroke: 0.5pt + rgb("#9CA3AF"),
    )

    start = end
  }

  // Заголовок
  content(
    (0, -radius - 1.5),
    text(size: 11pt, weight: "bold")[Распределение технологий контейнеризации, 2025],
  )
})

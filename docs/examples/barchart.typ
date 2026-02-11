// Пример: Горизонтальная столбчатая диаграмма
#set page(width: auto, height: auto, margin: 1em)
#set text(font: "Liberation Serif", size: 12pt)

#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3": chart

#cetz.canvas({
  import cetz.draw: *

  chart.barchart(
    (
      ([Q1 2024], 142),
      ([Q2 2024], 186),
      ([Q3 2024], 231),
      ([Q4 2024], 278),
      ([Q1 2025], 310),
      ([Q2 2025], 345),
    ),
    size: (14, 9),
    x-label: [Количество запросов к API (тыс.)],
    bar-style: (idx) => {
      let colors = (
        rgb("#2563EB"),
        rgb("#3B82F6"),
        rgb("#60A5FA"),
        rgb("#7C3AED"),
        rgb("#8B5CF6"),
        rgb("#A78BFA"),
      )
      (stroke: none, fill: colors.at(calc.rem(idx, colors.len())))
    },
  )
})

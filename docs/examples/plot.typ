// Пример: Сложный график с несколькими кривыми
#set page(width: auto, height: auto, margin: 1em)
#set text(font: "Liberation Serif", size: 12pt)

#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3": plot

#cetz.canvas({
  import cetz.draw: *

  plot.plot(
    size: (14, 9),
    x-label: [Время $t$, с],
    y-label: [Амплитуда $A(t)$],
    axis-style: "scientific",
    x-tick-step: 1,
    y-tick-step: 0.5,
    x-grid: "major",
    y-grid: "major",
    legend: "inner-north-east",
    {
      // Затухающая синусоида
      plot.add(
        domain: (0, 8),
        x => calc.exp(-0.3 * x) * calc.sin(2 * calc.pi * x * 0.5),
        label: [$e^(-0.3t) sin(pi t)$],
        style: (stroke: (paint: rgb("#2563EB"), thickness: 2pt)),
      )

      // Огибающая сверху
      plot.add(
        domain: (0, 8),
        x => calc.exp(-0.3 * x),
        label: [Огибающая $e^(-0.3t)$],
        style: (stroke: (paint: rgb("#DC2626"), thickness: 1.2pt, dash: "dashed")),
      )

      // Огибающая снизу
      plot.add(
        domain: (0, 8),
        x => -calc.exp(-0.3 * x),
        label: [$-e^(-0.3t)$],
        style: (stroke: (paint: rgb("#DC2626"), thickness: 1.2pt, dash: "dashed")),
      )

      // Вторая гармоника (меньшая амплитуда, выше частота)
      plot.add(
        domain: (0, 8),
        x => 0.4 * calc.exp(-0.5 * x) * calc.sin(2 * calc.pi * x * 1.2),
        label: [$0.4 e^(-0.5t) sin(2.4 pi t)$],
        style: (stroke: (paint: rgb("#16A34A"), thickness: 1.5pt)),
      )
    },
  )
})

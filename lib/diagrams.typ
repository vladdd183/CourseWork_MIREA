// ============================================================================
// 📊 ОБЁРТКИ ДЛЯ CeTZ / CeTZ-Plot
// ============================================================================
//
// Преднастроенные стили для графиков, блок-схем и диаграмм
// в формате, совместимом с ГОСТ (шрифт Times New Roman в подписях,
// правильные размеры текста).
//
// Зависимости (подтягиваются автоматически из Typst Universe):
//   @preview/cetz:0.4.2
//   @preview/cetz-plot:0.1.3
//
// Справочник примеров диаграмм: https://diagrams.janosh.dev/
// Документация CeTZ-Plot: https://github.com/cetz-package/cetz-plot
//
// Использование в content/:
//   #import "../lib/diagrams.typ": gost-canvas, gost-plot, flowchart
//
// НЕ РЕДАКТИРУЙТЕ этот файл при написании курсовой.
// ============================================================================

#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3": plot, chart

// ============================================================================
// 🎨 Канвас с ГОСТ-совместимыми настройками шрифтов
// ============================================================================
//
// Обёртка над cetz.canvas с правильным шрифтом для подписей.
//
// Пример:
//   #gost-canvas({
//     import cetz.draw: *
//     circle((0, 0), radius: 1)
//     content((0, 0), [Центр])
//   })
//
#let gost-canvas(body, ..args) = {
  set text(font: "Times New Roman", size: 12pt)
  cetz.canvas(..args, body)
}

// ============================================================================
// 📈 График с ГОСТ-настройками
// ============================================================================
//
// Обёртка для построения графиков через CeTZ-Plot с правильными шрифтами.
//
// Пример:
//   #gost-plot(
//     size: (10, 6),
//     x-label: [Время, с],
//     y-label: [Значение],
//     x-tick-step: 1,
//     y-tick-step: 10,
//     {
//       plot.add(domain: (0, 5), x => calc.pow(x, 2))
//     }
//   )
//
#let gost-plot(
  body,
  size: (12, 8),
  x-label: none,
  y-label: none,
  ..args,
) = {
  gost-canvas({
    import cetz.draw: *
    plot.plot(
      size: size,
      x-label: x-label,
      y-label: y-label,
      axis-style: "scientific",
      ..args,
      body,
    )
  })
}

// ============================================================================
// 🔄 Блок-схема (flowchart)
// ============================================================================
//
// Удобные примитивы для блок-схем алгоритмов.
//
// Пример:
//   #gost-canvas({
//     import cetz.draw: *
//     flowchart-block((0, 0), [Начало], shape: "stadium")
//     flowchart-block((0, -2), [Обработка данных])
//     flowchart-block((0, -4), [Условие?], shape: "diamond")
//     flowchart-block((0, -6), [Конец], shape: "stadium")
//     flowchart-arrow((0, -0.5), (0, -1.5))
//     flowchart-arrow((0, -2.5), (0, -3.3))
//     flowchart-arrow((0, -4.7), (0, -5.5))
//   })
//

// Блок блок-схемы
// shape: "rect" (процесс), "diamond" (условие), "stadium" (терминатор)
#let flowchart-block(canvas-ctx, pos, content, shape: "rect", width: 3, height: 1) = {
  import cetz.draw: *

  if shape == "rect" {
    rect(
      (pos.at(0) - width / 2, pos.at(1) - height / 2),
      (pos.at(0) + width / 2, pos.at(1) + height / 2),
      stroke: 0.5pt,
    )
  } else if shape == "diamond" {
    // Ромб для условия
    let hw = width / 2
    let hh = height / 2 * 1.3
    line(
      (pos.at(0), pos.at(1) + hh),
      (pos.at(0) + hw, pos.at(1)),
      (pos.at(0), pos.at(1) - hh),
      (pos.at(0) - hw, pos.at(1)),
      close: true,
      stroke: 0.5pt,
    )
  } else if shape == "stadium" {
    rect(
      (pos.at(0) - width / 2, pos.at(1) - height / 2),
      (pos.at(0) + width / 2, pos.at(1) + height / 2),
      radius: height / 2,
      stroke: 0.5pt,
    )
  }

  cetz.draw.content(pos, content)
}

// Стрелка между блоками
#let flowchart-arrow(from, to) = {
  import cetz.draw: *
  line(from, to, mark: (end: ">"), stroke: 0.5pt)
}

// ============================================================================
// 🥧 Круговая диаграмма
// ============================================================================
//
// Пример:
//   #gost-piechart(
//     (
//       ([Docker], 45),
//       ([Kubernetes], 30),
//       ([Podman], 15),
//       ([Другое], 10),
//     )
//   )
//
#let gost-piechart(data, radius: 2) = {
  gost-canvas({
    import cetz.draw: *
    chart.piechart(
      data,
      radius: radius,
      outer-label: (content: "%"),
      slice-style: gradient.linear(
        rgb("#4A90D9"),
        rgb("#67B8A7"),
        rgb("#F5A623"),
        rgb("#D0021B"),
      ),
    )
  })
}

// ============================================================================
// 📊 Столбчатая диаграмма
// ============================================================================
//
// Пример:
//   #gost-barchart(
//     (
//       ([2022], 150),
//       ([2023], 230),
//       ([2024], 310),
//     ),
//     x-label: [Количество],
//   )
//
#let gost-barchart(data, x-label: none, y-label: none, size: (10, 6)) = {
  gost-canvas({
    import cetz.draw: *
    chart.barchart(
      data,
      size: size,
      x-label: x-label,
      y-label: y-label,
      bar-style: gradient.linear(rgb("#4A90D9"), rgb("#67B8A7")),
    )
  })
}

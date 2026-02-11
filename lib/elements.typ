// ============================================================================
// 🧩 УТИЛИТЫ ДЛЯ ЭЛЕМЕНТОВ ДОКУМЕНТА
// ============================================================================
//
// Удобные функции для вставки стандартных элементов по ГОСТ:
//
//   ЦИТИРОВАНИЕ:
//     cite-src(1)          → [1]
//     cite-src(1, 2, 3)    → [1, 2, 3]
//     cite-range(5, 7)     → [5-7]
//
//   РИСУНКИ:
//     fig("assets/img.png", "Название")
//     fig-placeholder("Здесь будет диаграмма")
//
//   ТАБЛИЦЫ:
//     tbl("Название", columns: ..., [A], [B], ...)
//     long-tbl("Название", columns: ..., header: ([A], [B]), [1], [2], ...)
//
//   КОД:
//     code-block("Название")[```python ... ```]
//     code-file("input/code/main.py", "Главный модуль")
//
//   ФОРМУЛЫ:
//     $ E = m c^2 $  (нумеруются автоматически)
//
//   КРОСС-ССЫЛКИ:
//     fig-num(<fig:label>)      → "2.1"
//     table-num(<tbl:label>)    → "1.3"
//     listing-num(<lst:label>)  → "3.2"
//
//   ПРИЛОЖЕНИЯ:
//     appendix("А", "Листинги кода")[...]
//
// Использование в content/:
//   #import "../lib/elements.typ": cite-src, fig, tbl
//
// НЕ РЕДАКТИРУЙТЕ этот файл при написании курсовой.
// ============================================================================

// ============================================================================
// 📖 СИСТЕМА ЦИТИРОВАНИЯ
// ============================================================================

/// Ссылка на источник(и) в тексте: [1] или [1, 2, 3]
///
/// Пример:
///   Как показано в #cite-src(1), ...
///   Исследования #cite-src(1, 2, 3) подтверждают...
#let cite-src(..nums) = {
  let numbers = nums.pos()
  [[#numbers.map(n => str(n)).join(", ")]]
}

/// Диапазон источников: [1-5]
///
/// Пример:
///   Согласно #cite-range(5, 7), ...
#let cite-range(from, to) = {
  [[#from\-#to]]
}

// ============================================================================
// 🔗 КРОСС-ССЫЛКИ (секционная нумерация)
// ============================================================================

/// Номер рисунка в формате "Раздел.Номер"
/// Пример: рисунок #fig-num(<fig:arch>)  →  рисунок 2.1
#let fig-num(label) = context {
  let ch = counter(heading.where(level: 1)).at(label).first()
  if ch == 0 { ch = 1 }
  let num = counter(figure.where(kind: image)).at(label).first()
  [#ch.#num]
}

/// Номер таблицы в формате "Раздел.Номер"
/// Пример: таблица #table-num(<tbl:compare>)  →  таблица 1.3
#let table-num(label) = context {
  let ch = counter(heading.where(level: 1)).at(label).first()
  if ch == 0 { ch = 1 }
  let num = counter(figure.where(kind: table)).at(label).first()
  [#ch.#num]
}

/// Номер листинга в формате "Раздел.Номер"
/// Пример: листинг #listing-num(<lst:db>)  →  листинг 3.2
#let listing-num(label) = context {
  let ch = counter(heading.where(level: 1)).at(label).first()
  if ch == 0 { ch = 1 }
  let num = counter(figure.where(kind: "listing")).at(label).first()
  [#ch.#num]
}

// ============================================================================
// 🖼️ РИСУНКИ
// ============================================================================

/// Рисунок по ГОСТ: "Рисунок N.M — Название"
///
/// Пример:
///   #fig("assets/arch.png", "Архитектура системы")
///   #fig("assets/arch.png", "Архитектура", width: 80%)
#let fig(
  path,
  caption,
  width: 80%,
) = {
  figure(
    image(path, width: width),
    caption: caption,
    kind: image,
    supplement: [Рисунок],
  )
}

/// Заглушка для рисунка (когда изображение ещё не готово)
///
/// Пример:
///   #fig-placeholder("Диаграмма компонентов системы")
#let fig-placeholder(
  caption,
  width: 80%,
  height: 150pt,
  text-content: [_Здесь будет изображение_],
) = {
  figure(
    rect(
      width: width,
      height: height,
      fill: luma(245),
      stroke: 0.5pt + luma(200),
      align(center + horizon, text-content),
    ),
    caption: caption,
    kind: image,
    supplement: [Рисунок],
  )
}

// ============================================================================
// 📋 ТАБЛИЦЫ
// ============================================================================

/// Таблица по ГОСТ: "Таблица N.M — Название"
///
/// Пример:
///   #tbl(
///     "Сравнение технологий",
///     columns: (1fr, 1fr, 1fr),
///     zebra: true,
///     [Технология], [Плюсы], [Минусы],
///     [Docker], [Изоляция], [Overhead],
///   )
#let tbl(
  caption,
  columns: (),
  zebra: false,
  ..cells,
) = {
  let fill-fn = if zebra {
    (_, y) => if y > 0 and calc.even(y) { luma(248) }
  } else {
    (_, y) => if y == 0 { luma(240) }
  }

  figure(
    block(breakable: false, {
      set text(size: 12pt)
      table(
        columns: columns,
        stroke: 0.5pt + black,
        inset: 8pt,
        align: (col, row) => if row == 0 { center } else { left },
        fill: fill-fn,
        ..cells,
      )
    }),
    caption: caption,
    kind: table,
    supplement: [Таблица],
  )
}

/// Длинная таблица с повторяющимися заголовками (может разрываться)
///
/// Пример:
///   #long-tbl(
///     "Результаты тестирования",
///     columns: (1fr, 1fr, auto),
///     header: ([Тест], [Результат], [Время]),
///     [Unit], [OK], [0.5с],
///     [Integration], [OK], [2.1с],
///     // ...много строк...
///   )
#let long-tbl(
  caption,
  columns: (),
  header: (),
  zebra: false,
  ..cells,
) = {
  let fill-fn = if zebra {
    (_, y) => if y > 0 and calc.even(y) { luma(248) }
  } else {
    (_, y) => if y == 0 { luma(240) }
  }

  figure(
    block(breakable: true, {
      set text(size: 12pt)
      table(
        columns: columns,
        stroke: 0.5pt + black,
        inset: 8pt,
        align: (col, row) => if row == 0 { center } else { left },
        fill: fill-fn,
        table.header(repeat: true, ..header),
        ..cells,
      )
    }),
    caption: caption,
    kind: table,
    supplement: [Таблица],
  )
}

// ============================================================================
// 💻 КОД
// ============================================================================

// Моноширинные шрифты
#let _mono-font = ("JetBrains Mono", "Fira Code", "Liberation Mono", "DejaVu Sans Mono", "Courier New")

/// Блок кода с подписью и номерами строк
///
/// Пример:
///   #code-block("Подключение к БД", lang: "python")[
///     ```python
///     import psycopg2
///     conn = psycopg2.connect("dbname=test")
///     ```
///   ]
#let code-block(
  caption,
  lang: none,
  line-numbers: true,
  breakable: true,
  body,
) = {
  figure(
    block(
      fill: luma(248),
      stroke: (left: 3pt + rgb("#492F8C"), rest: 0.5pt + luma(200)),
      inset: 0pt,
      width: 100%,
      breakable: breakable,
      {
        set text(font: _mono-font, size: 11pt)
        set par(justify: false, leading: 0.6em)

        if line-numbers {
          show raw.line: it => {
            box(
              width: 100%,
              inset: (x: 8pt, y: 2pt),
              grid(
                columns: (25pt, 1fr),
                column-gutter: 8pt,
                align(right, text(fill: luma(150), size: 0.9em, str(it.number))),
                it.body,
              ),
            )
          }
        }

        body
      },
    ),
    caption: caption,
    kind: "listing",
    supplement: [Листинг],
  )
}

/// Листинг из файла с автоопределением языка
///
/// Пример:
///   #code-file("input/code/main.py", "Главный модуль")
///   #code-file("input/code/config.yaml", "Конфигурация", line-numbers: false)
#let code-file(
  path,
  caption,
  lang: auto,
  line-numbers: true,
  breakable: true,
) = {
  let code = read(path)
  let detected-lang = if lang == auto {
    let ext = path.split(".").last()
    (
      py: "python", js: "javascript", ts: "typescript", rs: "rust",
      go: "go", java: "java", c: "c", cpp: "cpp", sql: "sql",
      typ: "typst", html: "html", css: "css", json: "json",
      yaml: "yaml", yml: "yaml", sh: "bash", nix: "nix",
      toml: "toml", xml: "xml", md: "markdown",
    ).at(ext, default: none)
  } else {
    lang
  }

  figure(
    block(
      fill: luma(248),
      stroke: (left: 3pt + rgb("#492F8C"), rest: 0.5pt + luma(200)),
      inset: 0pt,
      width: 100%,
      breakable: breakable,
      {
        set text(font: _mono-font, size: 11pt)
        set par(justify: false, leading: 0.6em)

        if line-numbers {
          show raw.line: it => {
            box(
              width: 100%,
              inset: (x: 8pt, y: 2pt),
              grid(
                columns: (25pt, 1fr),
                column-gutter: 8pt,
                align(right, text(fill: luma(150), size: 0.9em, str(it.number))),
                it.body,
              ),
            )
          }
        }

        raw(code, lang: detected-lang, block: true)
      },
    ),
    caption: caption,
    kind: "listing",
    supplement: [Листинг],
  )
}

// ============================================================================
// 📐 ФОРМУЛЫ
// ============================================================================

// Формулы нумеруются автоматически через core.typ.
// Просто используйте блочный math:
//   $ E = m c^2 $  →  (2.1)

// ============================================================================
// 📎 ПРИЛОЖЕНИЯ
// ============================================================================

// Буквы приложений по ГОСТ (исключены Ё, З, Й, О, Ч, Ь, Ы, Ъ)
#let _appendix-letters = ("А", "Б", "В", "Г", "Д", "Ж", "И", "К", "Л", "М", "Н", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ш", "Щ", "Э", "Ю", "Я")

/// Приложение
///
/// Пример:
///   #appendix("А", "Листинги кода")[
///     #code-file("input/code/main.py", "Главный модуль")
///   ]
#let appendix(letter, title, body) = {
  pagebreak()

  // МИРЭА: 16pt полужирный, по центру, без абзацного отступа
  align(center)[
    #text(size: 16pt, weight: "bold")[ПРИЛОЖЕНИЕ #letter]
    #v(6pt)
    #text(size: 16pt, weight: "bold")[#title]
  ]
  v(20pt)

  body
}

/// Оглавление приложений (вставлять перед приложениями)
///
/// Пример:
///   #appendix-toc(("Листинги кода", "Результаты тестирования"))
#let appendix-toc(items) = {
  heading(level: 1, numbering: none, outlined: true)[Приложения]

  set par(first-line-indent: 0pt)

  table(
    columns: (auto, 1fr),
    stroke: none,
    inset: (x: 0pt, y: 6pt),
    ..items.enumerate().map(((i, title)) => {
      let letter = _appendix-letters.at(i, default: str(i + 1))
      ([*Приложение #letter*], title)
    }).flatten(),
  )
}

// ============================================================================
// ✍️ ПОДПИСЬ
// ============================================================================

/// Линия для подписи
#let sign-line(width: 3cm) = box(
  width: width,
  stroke: (bottom: 0.5pt + black),
  outset: (bottom: 2pt),
  [],
)

/// Блок подписи с расшифровкой
#let signature-block(width: 3.5cm) = {
  grid(
    columns: (width, 0.5cm, width),
    align: center,
    box(width: 100%, stroke: (bottom: 0.5pt + black), outset: (bottom: 2pt))[],
    [/],
    box(width: 100%, stroke: (bottom: 0.5pt + black), outset: (bottom: 2pt))[],
  )
  v(2pt)
  grid(
    columns: (width, 0.5cm, width),
    align: center,
    text(size: 9pt)[(подпись)],
    [],
    text(size: 9pt)[(расшифровка)],
  )
}

// ============================================================================
// 🏗️ ЯДРО ШАБЛОНА — apply-template()
// ============================================================================
//
// Главная функция шаблона. Настраивает:
//   - Параметры страницы (поля, размер, нумерация)
//   - Шрифт и межстрочный интервал (с цепочкой фоллбэков)
//   - Абзацный отступ
//   - Секционную нумерацию (Рисунок 2.1, Таблица 1.3 и т.д.)
//   - Сброс счётчиков при новом разделе
//   - Стили inline-кода и блоков кода
//   - Генерирует титульный лист и оглавление
//
// Вызывается из main.typ через:
//   #show: apply-template.with(meta: meta)
//
// НЕ РЕДАКТИРУЙТЕ этот файл при написании курсовой.
// ============================================================================

#import "title-page.typ": make-title-page
#import "headings.typ": apply-heading-styles
#import "bibliography.typ": apply-bibliography-styles

// ============================================================================
// 🎨 КОНСТАНТЫ ОФОРМЛЕНИЯ ПО ГОСТ
// ============================================================================

// Размеры шрифтов
#let font-size-main = 14pt
#let font-size-h1 = 18pt
#let font-size-h2 = 16pt
#let font-size-h3 = 14pt
#let font-size-caption = 12pt
#let font-size-code = 11pt

// Интервалы
#let heading-space-before = 15pt
#let heading-space-after = 10pt

// Шрифты — цепочка фоллбэков (приоритет Times New Roman)
#let main-font-default = ("Times New Roman", "Liberation Serif", "Noto Serif", "DejaVu Serif", "PT Serif")
#let mono-font = ("JetBrains Mono", "Fira Code", "Liberation Mono", "DejaVu Sans Mono", "Courier New")

// ============================================================================
// 🏗️ ГЛАВНАЯ ФУНКЦИЯ ШАБЛОНА
// ============================================================================

#let apply-template(
  meta: (:),
  body,
) = {
  // Извлекаем параметры форматирования
  let fmt = meta.at("formatting", default: (:))

  // Шрифт: пользовательский или цепочка фоллбэков
  let user-font = fmt.at("font-family", default: none)
  let main-font = if user-font != none { (user-font,) + main-font-default } else { main-font-default }

  // === Метаданные PDF ===
  set document(
    title: meta.at("title", default: "Курсовая работа"),
    author: meta.at("student", default: (:)).at("name", default: ""),
  )

  // === Настройка страницы ===
  let page-num-align = fmt.at("page-numbering-align", default: center)
  set page(
    paper: "a4",
    margin: (
      top: fmt.at("margin-top", default: 20mm),
      bottom: fmt.at("margin-bottom", default: 20mm),
      left: fmt.at("margin-left", default: 30mm),
      right: fmt.at("margin-right", default: 10mm),
    ),
    // Нумерация: цифра по центру внизу, 12pt (МИРЭА)
    numbering: none,
    footer: context {
      let loc = here()
      // Не показываем на титульном листе (стр. 1)
      if counter(page).get().first() > 1 {
        align(page-num-align,
          text(size: 12pt)[#counter(page).display("1")]
        )
      }
    },
  )

  // === Шрифт ===
  set text(
    font: main-font,
    size: fmt.at("font-size", default: font-size-main),
    lang: "ru",
    region: "RU",
    hyphenate: true,
  )

  // === Абзац ===
  let par-indent = fmt.at("paragraph-indent", default: 1.25cm)
  let spacing = fmt.at("line-spacing", default: 1.5em)
  set par(
    justify: true,
    first-line-indent: (amount: par-indent),
    leading: spacing,
    spacing: spacing,
  )

  // === Нумерация заголовков ===
  set heading(numbering: "1.1.1")

  // === Разделитель подписей ===
  set figure.caption(separator: [ — ])

  // =========================================================================
  // 📊 СЕКЦИОННАЯ НУМЕРАЦИЯ (Рисунок 2.1, Таблица 1.3)
  // =========================================================================

  // --- Рисунки ---
  // "Рисунок N.M — Название" под рисунком, по центру, 12pt полужирный
  show figure.where(kind: image): it => {
    block(breakable: false, width: 100%, {
      set par(first-line-indent: 0pt)
      align(center)[
        #it.body
        #v(6pt)
        #text(size: font-size-caption, weight: "bold")[
          Рисунок #context {
            let ch = counter(heading.where(level: 1)).get().first()
            if ch == 0 { ch = 1 }
            let num = counter(figure.where(kind: image)).get().first()
            [#ch.#num]
          }
          #if it.caption != none [ — #it.caption.body]
        ]
      ]
      v(6pt)
    })
  }

  // --- Таблицы ---
  // "Таблица N.M — Название" над таблицей, слева, без абзацного отступа
  show figure.where(kind: table): it => {
    block(breakable: false, width: 100%, {
      set par(first-line-indent: 0pt)
      v(6pt)
      text(size: font-size-main)[
        Таблица #context {
          let ch = counter(heading.where(level: 1)).get().first()
          if ch == 0 { ch = 1 }
          let num = counter(figure.where(kind: table)).get().first()
          [#ch.#num]
        }
        #if it.caption != none [ — #it.caption.body]
      ]
      v(6pt)
      it.body
      v(6pt)
    })
  }

  // --- Листинги ---
  // "Листинг N.M — Название"
  show figure.where(kind: "listing"): it => {
    block(breakable: true, width: 100%, {
      set par(first-line-indent: 0pt)
      v(6pt)
      text(size: font-size-main)[
        Листинг #context {
          let ch = counter(heading.where(level: 1)).get().first()
          if ch == 0 { ch = 1 }
          let num = counter(figure.where(kind: "listing")).get().first()
          [#ch.#num]
        }
        #if it.caption != none [ — #it.caption.body]
      ]
      v(6pt)
      it.body
      v(6pt)
    })
  }

  // --- Формулы ---
  // Нумерация: (N.M), секционная
  set math.equation(
    block: true,
    numbering: num => context {
      let ch = counter(heading.where(level: 1)).get().first()
      if ch == 0 { ch = 1 }
      [(#ch.#num)]
    },
    number-align: end + horizon,
  )

  // Отступы вокруг формул (ГОСТ: минимум 1 свободная строка)
  show math.equation.where(block: true): it => {
    v(0.5em)
    it
    v(0.5em)
  }

  // =========================================================================
  // 💻 СТИЛИ КОДА
  // =========================================================================

  // Блоки кода — цветная рамка слева
  show raw.where(block: true): it => {
    set text(font: mono-font, size: font-size-code)
    set par(justify: false, leading: 0.6em)
    block(
      fill: luma(248),
      stroke: (left: 3pt + rgb("#492F8C"), rest: 0.5pt + luma(200)),
      inset: 10pt,
      width: 100%,
      breakable: true,
      it,
    )
  }

  // Inline-код — фоновая подсветка
  show raw.where(block: false): box.with(
    fill: luma(245),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  // =========================================================================
  // 📋 СПИСКИ ПО ГОСТ
  // =========================================================================

  set list(indent: par-indent, marker: [—])
  set enum(indent: par-indent)

  // =========================================================================
  // 📄 СБОРКА ДОКУМЕНТА
  // =========================================================================

  // --- Титульный лист ---
  make-title-page(
    university: meta.at("university", default: ""),
    institute: meta.at("institute", default: ""),
    department: meta.at("department", default: ""),
    doc-type: meta.at("doc-type", default: "coursework"),
    discipline: meta.at("discipline", default: ""),
    title: meta.at("title", default: ""),
    variant: meta.at("variant", default: none),
    student: meta.at("student", default: (:)),
    supervisor: meta.at("supervisor", default: (:)),
    city: meta.at("city", default: ""),
    year: meta.at("year", default: ""),
  )

  // --- Оглавление ---
  {
    show heading: set heading(numbering: none)
    heading(level: 1)[Содержание]
    set text(size: font-size-main)
    set par(first-line-indent: 0pt)

    show outline.entry.where(level: 1): it => {
      v(0.3em)
      strong(it)
    }

    outline(
      title: none,
      indent: 1.5em,
      depth: 3,
    )
    pagebreak()
  }

  // --- Список сокращений (если есть) ---
  {
    let abbrevs = meta.at("abbreviations", default: ())
    if abbrevs.len() > 0 {
      show heading: set heading(numbering: none)
      heading(level: 1, outlined: true)[Список используемых сокращений]
      set par(first-line-indent: 0pt)
      table(
        columns: (auto, 1fr),
        stroke: none,
        inset: (x: 0pt, y: 4pt),
        ..abbrevs.map(a => ([*#a.abbr*], a.full)).flatten(),
      )
      pagebreak()
    }
  }

  // --- Стили заголовков (со сбросом счётчиков) ---
  show: apply-heading-styles

  // --- Стили библиографии ---
  show: apply-bibliography-styles

  // --- Основное содержимое ---
  body
}

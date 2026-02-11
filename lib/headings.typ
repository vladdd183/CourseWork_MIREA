// ============================================================================
// 📑 СТИЛИ ЗАГОЛОВКОВ ПО ГОСТ 7.32-2017
// ============================================================================
//
// Настраивает отображение заголовков всех уровней:
//   - Уровень 1: ПРОПИСНЫЕ, жирные, 18pt, по левому краю с отступом
//   - Уровень 2: Строчные жирные, 16pt, с абзацного отступа
//   - Уровень 3: Строчные жирные, 14pt, с абзацного отступа
//
// Каждый заголовок 1 уровня:
//   - Начинается с новой страницы
//   - Сбрасывает счётчики рисунков, таблиц, листингов, формул
//
// НЕ РЕДАКТИРУЙТЕ этот файл при написании курсовой.
// ============================================================================

// Константы
#let _font-size-h1 = 18pt
#let _font-size-h2 = 16pt
#let _font-size-h3 = 14pt
#let _par-indent = 1.25cm
#let _heading-space-before = 15pt
#let _heading-space-after = 10pt

// Применяет стили заголовков к документу
#let apply-heading-styles(body) = {

  // --- Заголовок 1 уровня ---
  // ПРОПИСНЫЕ, жирные, по левому краю с отступом, новая страница
  // Сброс счётчиков рисунков/таблиц/листингов/формул
  show heading.where(level: 1): it => {
    // Сброс секционных счётчиков
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: "listing")).update(0)
    counter(math.equation).update(0)

    pagebreak(weak: true)
    v(0pt)

    block(width: 100%, {
      set text(size: _font-size-h1, weight: "bold")
      set par(first-line-indent: 0pt, leading: 1em)
      if it.numbering != none {
        pad(left: _par-indent)[#counter(heading).display() #h(0.5em) #upper(it.body)]
      } else {
        pad(left: _par-indent)[#upper(it.body)]
      }
    })
    v(_heading-space-after)
  }

  // --- Заголовок 2 уровня ---
  // Строчные, жирные, с абзацного отступа
  show heading.where(level: 2): it => {
    v(_heading-space-before)
    block(width: 100%, {
      set text(size: _font-size-h2, weight: "bold")
      set par(first-line-indent: 0pt)
      pad(left: _par-indent)[#counter(heading).display() #h(0.5em) #it.body]
    })
    v(_heading-space-after)
  }

  // --- Заголовок 3 уровня ---
  // Строчные, жирные, с абзацного отступа
  show heading.where(level: 3): it => {
    v(_heading-space-before)
    block(width: 100%, {
      set text(size: _font-size-h3, weight: "bold")
      set par(first-line-indent: 0pt)
      pad(left: _par-indent)[#counter(heading).display() #h(0.5em) #it.body]
    })
    v(_heading-space-after)
  }

  body
}

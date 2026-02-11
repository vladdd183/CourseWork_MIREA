// Пример: Блок-схема алгоритма аутентификации
#set page(width: auto, height: auto, margin: 1em)
#set text(font: "Liberation Serif", size: 11pt)

#import "@preview/cetz:0.4.2"

// ---- Примитивы ----
#let fc-term(pos, label, w: 3.2, h: 0.9) = {
  import cetz.draw: *
  rect(
    (pos.at(0) - w / 2, pos.at(1) - h / 2),
    (pos.at(0) + w / 2, pos.at(1) + h / 2),
    radius: h / 2,
    stroke: 1.2pt + rgb("#1E40AF"),
    fill: rgb("#DBEAFE"),
  )
  content((pos.at(0), pos.at(1)), text(weight: "bold", fill: rgb("#1E40AF"), label))
}

#let fc-proc(pos, label, w: 3.8, h: 0.9) = {
  import cetz.draw: *
  rect(
    (pos.at(0) - w / 2, pos.at(1) - h / 2),
    (pos.at(0) + w / 2, pos.at(1) + h / 2),
    stroke: 1pt + rgb("#374151"),
    fill: rgb("#F3F4F6"),
  )
  content((pos.at(0), pos.at(1)), label)
}

#let fc-io(pos, label, w: 3.8, h: 0.9) = {
  import cetz.draw: *
  let dx = 0.3
  line(
    (pos.at(0) - w / 2 + dx, pos.at(1) - h / 2),
    (pos.at(0) + w / 2 + dx, pos.at(1) - h / 2),
    (pos.at(0) + w / 2 - dx, pos.at(1) + h / 2),
    (pos.at(0) - w / 2 - dx, pos.at(1) + h / 2),
    close: true,
    stroke: 1pt + rgb("#7C3AED"),
    fill: rgb("#EDE9FE"),
  )
  content((pos.at(0), pos.at(1)), label)
}

#let fc-cond(pos, label, w: 4.0, h: 1.6) = {
  import cetz.draw: *
  let hw = w / 2
  let hh = h / 2
  line(
    (pos.at(0), pos.at(1) + hh),
    (pos.at(0) + hw, pos.at(1)),
    (pos.at(0), pos.at(1) - hh),
    (pos.at(0) - hw, pos.at(1)),
    close: true,
    stroke: 1pt + rgb("#B45309"),
    fill: rgb("#FEF3C7"),
  )
  content((pos.at(0), pos.at(1)), text(size: 10pt, label))
}

#let arr(from, to) = {
  import cetz.draw: *
  line(from, to, mark: (end: ">", fill: rgb("#374151")), stroke: 1pt + rgb("#374151"))
}

#let arr-l(from, to, label, dx: 0.15, dy: 0) = {
  import cetz.draw: *
  line(from, to, mark: (end: ">", fill: rgb("#374151")), stroke: 1pt + rgb("#374151"))
  content(
    ((from.at(0) + to.at(0)) / 2 + dx, (from.at(1) + to.at(1)) / 2 + dy),
    text(size: 9pt, fill: rgb("#6B7280"), label),
  )
}

// ---- Основная диаграмма ----
#cetz.canvas({
  import cetz.draw: *

  // Начало
  fc-term((0, 0), [Начало])
  arr((0, -0.45), (0, -1.15))

  // Ввод
  fc-io((0, -1.6), [Ввод логина и пароля])
  arr((0, -2.05), (0, -2.75))

  // Валидация формата
  fc-cond((0, -3.55), [Формат\ валиден?])
  arr-l((0, -4.35), (0, -5.15), [Да], dx: 0.25)

  // Нет — вернуть ошибку (ветка вправо)
  arr-l((2.0, -3.55), (4.2, -3.55), [Нет], dy: 0.2)
  fc-proc((6.3, -3.55), [Ошибка формата], w: 3.0)
  arr((6.3, -3.1), (6.3, -1.6))
  line((6.3, -1.6), (1.9, -1.6), mark: (end: ">", fill: rgb("#374151")), stroke: 1pt + rgb("#374151"))

  // Запрос к БД
  fc-proc((0, -5.6), [Запрос к БД:\ поиск пользователя])
  arr((0, -6.05), (0, -6.75))

  // Пользователь найден?
  fc-cond((0, -7.55), [Пользователь\ найден?])
  arr-l((0, -8.35), (0, -9.15), [Да], dx: 0.25)

  // Нет — ошибка
  arr-l((2.0, -7.55), (4.2, -7.55), [Нет], dy: 0.2)
  fc-proc((6.3, -7.55), [Ошибка: не найден], w: 3.0)
  arr((6.3, -8.0), (6.3, -13.1))

  // Проверка пароля
  fc-proc((0, -9.6), [Хэширование и\ проверка пароля])
  arr((0, -10.05), (0, -10.75))

  // Пароль верный?
  fc-cond((0, -11.55), [Пароль\ верный?])
  arr-l((0, -12.35), (0, -13.15), [Да], dx: 0.25)

  // Нет — ошибка
  arr-l((2.0, -11.55), (4.2, -11.55), [Нет], dy: 0.2)
  fc-proc((6.3, -11.55), [Неверный пароль], w: 3.0)
  arr((6.3, -12.0), (6.3, -13.1))

  // Логирование (обе ветки ошибок сводятся сюда)
  fc-proc((6.3, -13.6), [Логирование\ результата], w: 3.0)
  arr((6.3, -14.05), (6.3, -16.8))

  // Генерация токена
  fc-proc((0, -13.6), [Генерация JWT-токена])
  arr((0, -14.05), (0, -14.75))

  // Вывод
  fc-io((0, -15.2), [Вернуть токен клиенту])
  arr((0, -15.65), (0, -16.35))

  // Конец
  fc-term((0, -16.8), [Конец])
  line((6.3, -16.8), (1.6, -16.8), mark: (end: ">", fill: rgb("#374151")), stroke: 1pt + rgb("#374151"))
})

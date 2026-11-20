#import "@preview/touying:0.8.0": *

#import "../common/cfg.typ": cfg

#let fonts = (
    sans: "HSE Sans",
    slab: "HSE Slab",
)

#let colors = (
    blue: rgb("#0F2C68"),
    black: rgb("#000000"),
    white: rgb("#ffffff"),
)

#let slide(..args) = touying-slide-wrapper(self => {
    let header(self) = {
        set align(top)

        show: block.with(
            inset: 3mm,
            fill: colors.blue,
            height: 30mm,
        )

        grid(
            columns: (auto, 1fr),
            align: (center + horizon, left + horizon),
            gutter: 3mm,

            image("res/hse-logo.svg", height: 100%),
            {
                set text(
                    fill: colors.white,
                    font: fonts.sans,
                    weight: "bold",
                    size: 25pt,
                )
                utils.display-current-heading(level: 1)
            },
        )
    }

    let footer(self) = {
        set align(bottom)

        show: block.with(
            inset: 2mm,
            height: 10mm,
        )

        set text(
            fill: colors.blue,
            font: fonts.sans,
            size: 10pt,
        )

        grid(
            columns: (auto, 1fr, auto),
            align: (left, center, right),
            row-gutter: 1.5mm,

            grid.cell(colspan: 3, line(
                length: 100%,
                stroke: 1pt + colors.black,
            )),

            [ФКН, ОП "#cfg.edu_program_name", #cfg.year],

            [#cfg.student.name, ВКР "#cfg.project.name.ru"],

            context [#utils.slide-counter.display() / #utils.last-slide-number],
        )
    }

    self = utils.merge-dicts(self, config-page(header: header, footer: footer))
    touying-slide(self: self, ..args)
})

#let vert-slide(orig_body) = touying-slide-wrapper(self => {
    let body = grid(
        rows: 1fr,
        columns: (1fr, 4fr),

        block(width: 100%, height: 100%, fill: colors.blue, inset: 10mm, {
            set align(center)
            image("res/hse-logo.svg", width: 25mm)
        }),
        block(width: 100%, height: 100%, inset: 5mm, orig_body),
    )

    self = utils.merge-dicts(self, config-page(margin: (rest: 0mm)))
    touying-slide(self: self, body)
})

#let title-slide() = vert-slide(grid(
    columns: 1fr,
    align: center,
    row-gutter: 1fr,

    [
        #cfg.faculty_name\
        Образовательная программа "#cfg.edu_program_name"\
        Выпускная квалификационная работа
    ],

    text(size: 18pt, font: fonts.sans, weight: "bold")[
        #cfg.project.name.ru_break
    ],

    text(size: 18pt, font: fonts.sans, weight: "bold")[
        #cfg.project.name.en
    ],

    [Проектная ВКР],

    align(right)[
        Выполнил студент группы БПИ232\
        образовательной программы\
        09.03.04 «Программная инженерия»\
        _Чубий Савва Андреевич_
    ],

    align(right)[
        Руководитель:\
        старший преподаватель департамента\ больших данных и информационного
        поиска\
        _Куренков Владимир Вячеславович_
    ],

    [Москва, 2026]
))



#let hse-theme(
    aspect-ratio: "16-9",
    lang: "ru",
    ..args,
    body,
) = {
    set text(
        font: fonts.slab,
        size: 14pt,
        lang: lang,
    )

    show: touying-slides.with(
        config-page(
            paper: "presentation-" + aspect-ratio,
            margin: (top: 35mm, bottom: 10mm, x: 5mm),
        ),
        config-common(slide-fn: slide),
        config-methods(slide: slide),
        ..args,
    )

    body
}

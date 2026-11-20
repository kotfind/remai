#let main(is_handout: none) = [
    #assert(type(is_handout) == bool)

    #import "template.typ": *

    #show: hse-theme.with(
        aspect-ratio: "16-9",
        config-common(handout: is_handout),
    )

    #title-slide()

    #include "slides.typ"
]

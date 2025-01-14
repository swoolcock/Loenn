local customHeightDisplay = {}

customHeightDisplay.name = "everest/CustomHeightDisplayTrigger"
customHeightDisplay.fieldInformation = {
    target = {
        fieldType = "integer",
    },
    from = {
        fieldType = "integer",
    },
}
customHeightDisplay.placements = {
    name = "custom_height_display",
    data = {
        vanilla = false,
        target = 0,
        from = 0,
        text = "{x}m",
        progressAudio = false,
        displayOnTransition = false
    }
}

return customHeightDisplay
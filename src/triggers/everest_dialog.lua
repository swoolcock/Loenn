local everestDialog = {}

everestDialog.name = "everest/dialogTrigger"
everestDialog.fieldInformation = {
    deathCount = {
        fieldType = "integer",
    }
}
everestDialog.placements = {
    name = "dialog",
    data = {
        endLevel = false,
        onlyOnce = true,
        dialogId = "",
        deathCount = -1
    }
}

return everestDialog
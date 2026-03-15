table.insert(props, {
  Name = "Debug Print",
  Type = "enum",
  Choices = {"None", "Tx/Rx", "Tx", "Rx", "Function Calls", "All"},
  Value = "None"
})

table.insert(props, {
  Name = "Max Components",
  Type = "integer",
  Value = 16,
  Min = 1,
  Max = 64
})

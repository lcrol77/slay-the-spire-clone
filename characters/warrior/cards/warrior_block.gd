extends Card

func apply_effects(targets: Array[Node]):
	var block := BlockEffect.new()
	block.amount = 5
	block.execute(targets)

class_name Battle
extends Node2D

@export var char_stats: CharacterStats
@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler

func _ready() -> void:
	# Normally, we would do this on a "run"
	# level so we  keep our health gold and deck 
	# between battles
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	start_battle(new_stats)

func start_battle(stats: CharacterStats):
	player_handler.start_battle(stats)

class_name Hand
extends HBoxContainer

@export var char_stats: CharacterStats

@onready var card_ui := preload("res://Scenes/CardUI/card_ui.tscn")
@onready var cards_played_this_turn := 0


func _ready() -> void:
	Events.card_played.connect(_on_card_played)

func add_card(card: Card)-> void:
	var new_card := card_ui.instantiate()
	add_child(new_card)
	new_card.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card.card = card
	new_card.parent = self
	new_card.char_stats = char_stats
	

func _on_card_played(_card: Card) -> void:
	cards_played_this_turn += 1

func _on_card_ui_reparent_requested(child: CardUI):
	child.disabled = true
	child.reparent(self)
	var new_index := clampi(child.original_index - cards_played_this_turn, 0, get_child_count())
	move_child.call_deferred(child, new_index)
	child.set_deferred("disabled", false)

func discard_card(card: CardUI):
	card.queue_free()

func disable_hand()-> void:
	for card in get_children():
		card.disabled = true

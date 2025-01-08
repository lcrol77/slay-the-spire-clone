class_name CardUI
extends Control

signal reparent_requested(which: CardUI)

const CARD_BASE_STYLEBOX = preload("res://Scenes/CardUI/card_base_stylebox.tres")
const CARD_DRAGGING_STYLEBOX = preload("res://Scenes/CardUI/card_dragging_stylebox.tres")
const CARD_HOVER_STYLEBOX = preload("res://Scenes/CardUI/card_hover_stylebox.tres")

@export var card: Card : set = _set_card
@export var char_stats: CharacterStats: set = _set_char_stats

@onready var panel: Panel = $Panel
@onready var mana_cost: Label = $ManaCost
@onready var icon: TextureRect = $Icon
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var targets: Array[Node] = []
@onready var original_index := self.get_index()

var parent: Control
var tween: Tween
var playable := true : set = _set_playable
var disabled := false

func _ready() -> void:
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_ended.connect(_on_card_drag_or_aiming_ended)
	Events.card_aim_ended.connect(_on_card_drag_or_aiming_ended)
	
	card_state_machine.init(self)

func _input(event: InputEvent):
	card_state_machine.on_input(event)

func _set_playable(val: bool) -> void:
	playable = val
	if not playable:
		mana_cost.add_theme_color_override("font_color", Color.RED)
		icon.modulate = Color(1,1,1,.5)
	else:
		mana_cost.remove_theme_color_override("font_color")
		icon.modulate=Color(1,1,1,1)

func _set_char_stats(value: CharacterStats):
	char_stats = value
	char_stats.stats_changed.connect(_on_char_stats_changed)

func _on_card_drag_or_aiming_started(used_card: CardUI):
	if used_card == self:
		return
	disabled = true

func _on_card_drag_or_aiming_ended(_used_card: CardUI):
	disabled = false
	self.playable = char_stats.can_play_card(card)
	
func _on_char_stats_changed():
	self.playable = char_stats.can_play_card(card)

func animate_to_pos(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)

func play() -> void:
	if not card:
		return
	card.play(targets, char_stats)
	queue_free()
	
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)

func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)

func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	card = value
	mana_cost.text = str(card.cost)
	icon.texture = card.icon 

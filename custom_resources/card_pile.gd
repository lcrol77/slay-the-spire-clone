class_name CardPile
extends Resource

signal card_pile_size_changed(amount)

@export var cards: Array[Card] = []

func draw_card() -> Card:
	var card = cards.pop_front()
	card_pile_size_changed.emit(cards.size())
	return card

func add_card(card: Card):
	cards.append(card)
	card_pile_size_changed.emit(cards.size())

func shuffle():
	cards.shuffle()

func clear():
	cards.clear()
	card_pile_size_changed.emit(cards.size())

func empty() -> bool:
	return cards.size() == 0

func _to_string() -> String:
	var _card_strings:PackedStringArray = []
	for i in range(cards.size()):
		_card_strings.append("%s: %s" % [i+1, cards[i].id])
	return "\n".join(_card_strings)

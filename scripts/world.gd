extends Node2D

var total_number = 0

const CARD_VALUES = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, "R", -10, 99, "P2"]

var reversed = true
var play_amount = 1

var selected_index = 0

var p1_cards = []
var p2_cards = []
# 11 = Reverse
# 12 = -10
# 13 = ONO 99
# 14 = Place 2


func _ready():
	setup()


func refresh_cards():
	var count = 0
	for card in $Player1.get_children():
		card.texture = null
	while count != p1_cards.size():
		get_node(str("Player1/Card", str(count))).texture = load(str("res://sprites/", str(p1_cards[count]), ".png"))
		count += 1

func add_card(cards):
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var card_index = rng.randi_range(0, CARD_VALUES.size() - 1)
	var card = CARD_VALUES[card_index]
	
	cards.append(card)

func setup():
	while p1_cards.size() != 7:
		add_card(p1_cards)
	# setup cards visually for player to see their cards
	refresh_cards()

	while p2_cards.size() != 7:
		add_card(p2_cards)

func add(n):
	total_number += n
	
func reverse():
	reversed = !reversed
	
func skip():
	pass

func draw_card(card):
	if card.size() != 7:
		add_card(card)

	
func _physics_process(_delta):
	
	#print(p1_cards)
	#print(p2_cards)
	
	$currentselected.text = str(selected_index)
	$Amount.text = str(total_number)

	if total_number >= 99:
		total_number = 0
		
	if Input.is_action_just_pressed("ui_right"):
		if !selected_index + 1 == p1_cards.size():
			selected_index += 1
		else:
			selected_index = 0
			
	elif Input.is_action_just_pressed("ui_left"):
		if !selected_index - 1 == -1:
			selected_index -= 1
		else:
			selected_index = 6

	# probably unnecessary, but backup if it ever happens lol
	if selected_index > (p1_cards.size() - 1):
		selected_index = p1_cards.size() - 1
	
	if selected_index < 0:
		selected_index = 0
		
		
	if Input.is_action_just_pressed("ui_accept"):
		if !p1_cards.is_empty():
			place_card_visual()
			p1_cards.remove_at(selected_index)
			refresh_cards()
			
	if Input.is_action_just_pressed("ui_b"):
		draw_card(p1_cards)
		refresh_cards()
	



func place_card_visual():
	var texture = get_node(str("Player1/Card", str(selected_index))).texture
	for s in $CardsPlaced.get_children():
		if s.texture == null:
			s.texture = texture
			return
			
	# only ran when first for loop wasnt returned, meaning there are no more null card textures
	# we reset all card textures
	for s in $CardsPlaced.get_children():
		s.texture = null
		
	# then run the first for loop again
	for s in $CardsPlaced.get_children():
		if s.texture == null:
			s.texture = texture
			break

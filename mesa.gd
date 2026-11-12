extends Node2D
@onready var baralho_node = $Baralho
var areaWEL = Area2D
var WELsprite = Sprite2D
var E: int = 0
var W: int = 0
var L: int = 0
var valor: int = 0
var valor2: int = 0
var cartas_jogadas: int = 0
var areas_bot: Array[Area2D] = []
var cartas_bot: Array[Carta] = []
var sprites_bot: Array[Sprite2D] = []
var ponto: int = 1
var pponto: int = 0
var bponto: int = 0
var rodfim: bool = false
var botaoproxrodada: TextureButton
var BotaoTruco: TextureButton
var BotaoPoder: TextureButton
var truco: int = 0
var primeiramao: int = 0
func _ready() -> void:
	criar_fundo()
	baralho_node.criarBaralho()
	criar_botao()
	turno()
func criar_fundo() -> void:
	var camada = CanvasLayer.new()
	camada.layer = -1
	add_child(camada)
	var fundo = TextureRect.new()
	fundo.texture = load("res://sprites/PlaceHolders/cenario.png")
	fundo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fundo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fundo.stretch_mode = TextureRect.STRETCH_SCALE
	fundo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	camada.add_child(fundo)
func criar_botao() -> void:
	BotaoTruco = TextureButton.new()
	BotaoPoder = TextureButton.new()
	BotaoTruco .texture_normal = load("res://sprites/PlaceHolders/Butao.png")
	BotaoTruco .texture_hover = load("res://sprites/PlaceHolders/Butao.png")
	BotaoTruco .texture_pressed = load("res://sprites/PlaceHolders/Butao.png")
	BotaoPoder.texture_normal = load("res://sprites/PlaceHolders/Butao.png")
	BotaoPoder.texture_hover = load("res://sprites/PlaceHolders/Butao.png")
	BotaoPoder.texture_pressed = load("res://sprites/PlaceHolders/Butao.png")
	BotaoTruco .position = Vector2(800,1025)
	BotaoPoder.position = Vector2(1025,1025)
	BotaoTruco .pressed.connect(trucar)
	BotaoPoder.pressed.connect(poder)
	add_child(BotaoTruco)
	add_child(BotaoPoder)
func turno() -> void:
	Globais.distribuir()
	for i in range(3):
		var carta = Globais.maoP[i]
		var area = Area2D.new()
		area.input_pickable = true
		area.collision_layer = 1
		var sprite = Sprite2D.new()
		sprite.scale = Vector2(0.45, 0.45)
		sprite.texture = load("res://sprites/cartas/" + carta.num + "_" + carta.naipe + ".png")
		area.add_child(sprite)
		var colisao = CollisionShape2D.new()
		var forma = RectangleShape2D.new()
		forma.size = sprite.texture.get_size() * sprite.scale
		colisao.shape = forma
		area.add_child(colisao)
		area.position = Vector2(775 + i *170, 850)
		area.input_event.connect(carta_clicada.bind(carta, area))
		add_child(area)
	for j in range(3):
		var carta2 = Globais.maoO[j]
		var area2 = Area2D.new()
		area2.input_pickable = false
		var sprite2 = Sprite2D.new()
		sprite2.scale = Vector2(0.45, 0.45)
		sprite2.texture = load("res://sprites/cartas/Verso.png")
		area2.add_child(sprite2)
		area2.position = Vector2(775 + j *170, 200)
		add_child(area2)
		areas_bot.append(area2)
		cartas_bot.append(carta2)
		sprites_bot.append(sprite2)
func carta_clicada(
	viewport: Node,
	event: InputEvent,
	shape_idx: int,
	carta: Carta,
	area: Area2D
	) -> void:
	if rodfim:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			area.input_pickable = false
			cartas_jogadas += 1
			area.position = Vector2(485 + cartas_jogadas * 150, 525)
			valor = carta.valor
			Globais.maoP.erase(carta)
			print("Voce jogou: " + carta.num + " de " + carta.naipe + " Valor: " + str(valor))
			BotTurno()
			return
func BotTurno() -> void:
	if cartas_bot.is_empty():
			return
	var carta: Carta = cartas_bot[0]
	var area2: Area2D = areas_bot[0]
	var sprite2: Sprite2D = sprites_bot[0]
	valor2 = carta.valor
	cartas_jogadas +=1
	sprite2.texture = load("res://sprites/cartas/" + carta.num + "_" + carta.naipe + ".png")
	area2.position = Vector2(370 + cartas_jogadas * 150, 525)
	Globais.maoO.erase(carta)
	print("Bot jogou: " + carta.num + " de " + carta.naipe+ " Valor: " + str(valor2))
	cartas_bot.remove_at(0)
	areas_bot.remove_at(0)
	sprites_bot.remove_at(0)
	checar()
	winner()
	return
func checar() -> void:
	areaWEL = Area2D.new()
	WELsprite = Sprite2D.new()
	if valor > valor2:
		W += 1
		print("W")
		WELsprite.texture = load("res://sprites/PlaceHolders/Win.png")
		areaWEL.position = Vector2(380 + cartas_jogadas/2 * 290, 690)
	elif valor2 > valor:
		L += 1
		print("L")
		WELsprite.texture = load("res://sprites/PlaceHolders/Loss.png")
		areaWEL.position = Vector2(380 + cartas_jogadas/2 * 290, 690)
	else:
		E += 1
		print("E")
		WELsprite.texture = load("res://sprites/PlaceHolders/Emp.png")
		areaWEL.position = Vector2(380 + cartas_jogadas/2 * 290, 690)
	if cartas_jogadas == 2 and primeiramao == 0:
		if W > 0:
			primeiramao = 1
		if L > 0:
			primeiramao = 2
	areaWEL.add_child(WELsprite)
	add_child(areaWEL)
	return
func winner() -> void:
	if W == 2:
		rodfim = true
		pponto += ponto
		cabo()
		return
	elif L == 2:
		rodfim = true
		bponto += ponto
		cabo()
		return
	elif cartas_jogadas >= 6 or E > 0:
		if W > L:
			pponto += ponto
		elif L > W:
			bponto += ponto
		else:
			if primeiramao == 1:
				pponto += ponto
			else:
				bponto += ponto
		rodfim = true
		cabo()
		return
func cabo() -> void:
	rodfim = true
	BotaoPoder.disabled = true
	BotaoTruco.disabled = true
	botaoproxrodada = TextureButton.new()
	botaoproxrodada.texture_normal = load("res://sprites/PlaceHolders/Butao.png")
	botaoproxrodada.texture_hover = load("res://sprites/PlaceHolders/Butao.png")
	botaoproxrodada.texture_pressed = load("res://sprites/PlaceHolders/Butao.png")
	botaoproxrodada.position = Vector2 (1400, 500)
	botaoproxrodada.pressed.connect(proxrodada)
	add_child(botaoproxrodada)
func proxrodada() -> void:
	botaoproxrodada.queue_free()
	botaoproxrodada = null
	BotaoPoder.disabled = false
	BotaoTruco.disabled = false
	W = 0
	E = 0
	L = 0
	cartas_jogadas = 0
	valor = 0 
	valor2 = 0
	truco = 0
	areas_bot.clear()
	cartas_bot.clear()
	sprites_bot.clear()
	for filho in get_children():
		if filho is Area2D:
			filho.queue_free()
	rodfim = false
	print("Bot:" + str(bponto) + "Vc:" + str(pponto))
	turno()
func trucar() -> void:
	if truco >= 4:
		return
	truco += 1
	ponto  = 3*truco
	if truco == 4:
		BotaoTruco.disabled = true
		return
func poder() -> void:
	print("poder")

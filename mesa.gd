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
var aguard_bot: bool = false
var carta_troca: Carta
var area_troca: Area2D
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
	BotaoTruco .texture_normal = load("res://sprites/PlaceHolders/BotaoAntesdeAperta.png")
	BotaoTruco .texture_hover = load("res://sprites/PlaceHolders/BotaoAntesdeAperta.png")
	BotaoTruco .texture_pressed = load("res://sprites/PlaceHolders/BotaoApertado.png")
	BotaoPoder.texture_normal = load("res://sprites/PlaceHolders/Butao.png")
	BotaoPoder.texture_hover = load("res://sprites/PlaceHolders/Butao.png")
	BotaoPoder.texture_pressed = load("res://sprites/PlaceHolders/Butao.png")
	BotaoTruco .position = Vector2(750,950)
	BotaoPoder.position = Vector2(1025,1025)
	BotaoTruco .pressed.connect(trucar)
	BotaoPoder.pressed.connect(Globais.poder)
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
		area.set_meta("carta", carta)
		area.input_event.connect(carta_clicada.bind(area))
		add_child(area)
	for j in range(3):
		var carta2 = Globais.maoO[j]
		var area2 = Area2D.new()
		area2.input_pickable = true
		area2.collision_layer = 1
		var sprite2 = Sprite2D.new()
		sprite2.scale = Vector2(0.45, 0.45)
		sprite2.texture = load("res://sprites/cartas/Verso.png")
		area2.add_child(sprite2)
		var colisao2 = CollisionShape2D.new()
		var forma2 = RectangleShape2D.new()
		forma2.size = sprite2.texture.get_size() * sprite2.scale
		colisao2.shape = forma2
		area2.add_child(colisao2)
		area2.set_meta("carta", carta2)
		area2.input_event.connect(bot_carta_clicada.bind(area2))
		area2.position = Vector2(775 + j * 170, 200)
		add_child(area2)
		areas_bot.append(area2)
		cartas_bot.append(carta2)
		sprites_bot.append(sprite2)
func carta_clicada(
	viewport: Node,
	event: InputEvent,
	shape_idx: int,
	area: Area2D
	) -> void:
	if rodfim:
		return
	if  not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	if aguard_bot:
		return
	var carta: Carta = area.get_meta("carta")
	if Globais.arg_carta:
		carta.valor += 1
		var indicador = Sprite2D.new()
		indicador.texture = load("res://sprites/PlaceHolders/Butao.png")
		indicador.scale = Vector2 (0.45, 0.45)
		indicador.position = Vector2 (-60, -30)
		indicador.z_index = 1
		area.add_child(indicador)
		Globais.arg_carta = false
		Globais.poder_us = true
		return
	if Globais.arg_troca:
		carta_troca = carta
		area_troca = area
		aguard_bot = true
		Globais.arg_troca = false
		print("2")
		return
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
func bot_carta_clicada(
	viewport: Node,
	event: InputEvent,
	shape_idx: int,
	area_bot: Area2D
) -> void:
	if rodfim or not aguard_bot:
		return
	if not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	var carta_bot: Carta = area_bot.get_meta("carta")
	var indice_jogador = Globais.maoP.find(carta_troca)
	var indice_bot = cartas_bot.find(carta_bot)
	var indice_mao_bot = Globais.maoO.find(carta_bot)
	if indice_jogador == -1 or indice_bot == -1 or indice_mao_bot == -1:
		return
	Globais.maoP[indice_jogador] = carta_bot
	Globais.maoO[indice_mao_bot] = carta_troca
	cartas_bot[indice_bot] = carta_troca
	area_troca.set_meta("carta", carta_bot)
	area_bot.set_meta("carta", carta_troca)
	var sprite = area_troca.get_child(0) as Sprite2D
	sprite.texture = load("res://sprites/cartas/" + carta_bot.num + "_" + carta_bot.naipe + ".png")
	aguard_bot = false
	carta_troca = null
	area_troca = null
	Globais.poder_us = true
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
	elif cartas_jogadas >= 4 and E > 0:
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
	Globais.arg_carta = false
	Globais.arg_troca = false
	aguard_bot = false
	carta_troca = null
	area_troca = null
	Globais.poder_us = false
	W = 0
	E = 0
	L = 0
	cartas_jogadas = 0
	valor = 0 
	valor2 = 0
	truco = 0
	ponto = 1
	areas_bot.clear()
	cartas_bot.clear()
	sprites_bot.clear()
	for filho in get_children():
		if filho is Area2D:
			filho.queue_free()
	rodfim = false
	print("Bot:" + str(bponto) + " Vc:" + str(pponto))
	turno()
func trucar() -> void:
	if truco >= 4:
		return
	truco += 1
	ponto  = 3*truco
	if truco == 4:
		BotaoTruco.disabled = true
		return

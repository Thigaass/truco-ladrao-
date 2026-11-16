extends Node2D
func criarBaralho() -> void:
	Globais.baralho.clear()
	for naipe in ["Ouros", "Espadas", "Copas", "Paus"]:
		for num in ["As", "2", "3", "4", "5", "6", "7", "J", "Q", "K"]:
			var carta = Carta.new()
			carta.num = num
			carta.naipe = naipe
			if carta.num == ("7"):
				if carta.naipe == ("Ouros"):
					carta.valor = 11
				elif carta.naipe == ("Copas"):
					carta.valor = 13
				else:
					carta.valor = 4
			if carta.num == ("4"):
				if carta.naipe == ("Paus"):
					carta.valor = 14
				else:
					carta.valor = 1
			if carta.num == ("As"):
				if carta.naipe == ("Espadas"):
					carta.valor = 12
				else:
					carta.valor = 8
			if carta.num ==("5"):
				carta.valor = 2
			if carta.num ==("6"):
				carta.valor = 3
			if carta.num ==("J"):
				carta.valor = 6
			if carta.num ==("Q"):
				carta.valor = 5
			if carta.num ==("K"):
				carta.valor = 7
			if carta.num ==("2"):
				carta.valor = 9
			if carta.num ==("3"):
				carta.valor = 10
			Globais.baralho.append(carta)

extends Node
var baralho: Array[Carta] = []
var maoP: Array[Carta] = []
var maoO: Array[Carta] = []
var poder_esc: int = 0
var poder_us: bool = false
var arg_carta: bool = false
var arg_troca: bool = false
func poder() -> void:
	if poder_us:
		return
	match poder_esc:
		1:
			arg_carta = true
		2:
			arg_troca = true
		3:
			print("poder3")
		4:
			print("poder4")
func distribuir() -> void:
	baralho.shuffle()
	maoP = baralho.slice(0,3)
	maoO = baralho.slice(3,6)

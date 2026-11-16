extends Control
func _ready() -> void:
	$Panel/Jogar.pressed.connect(jogar)
	$Panel/Sair.pressed.connect(sair)
func jogar() -> void:
	get_tree().change_scene_to_file("res://poderes.tscn")
func sair() -> void:
	get_tree().quit()

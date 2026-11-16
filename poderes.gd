extends Control
func _ready() -> void:
	$Panel/Poder1.pressed.connect(func(): esc_poder(1))
	$Panel/Poder2.pressed.connect(func(): esc_poder(2))
	$Panel/Poder3.pressed.connect(func(): esc_poder(3))
	$Panel/Poder4.pressed.connect(func(): esc_poder(4))
func esc_poder(numero: int) -> void:
	Globais.poder_esc = numero
	print(Globais.poder_esc)
	get_tree().change_scene_to_file("res://Main.tscn")

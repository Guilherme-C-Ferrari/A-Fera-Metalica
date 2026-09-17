extends Node2D

func _ready() -> void:
	var intro = Dialogic.start("intro")
	add_child(intro)

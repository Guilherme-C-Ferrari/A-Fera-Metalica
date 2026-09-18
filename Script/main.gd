extends Node2D

func _ready() -> void:
	var intro = Dialogic.start("0_Intro")
	add_child(intro)

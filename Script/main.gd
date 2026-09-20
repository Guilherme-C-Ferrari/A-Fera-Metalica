extends Node2D

@export var animationPlayer : AnimationPlayer
@export var intro_scene: Control

func _ready() -> void:
	animationPlayer.animation_finished.connect(_on_intro_animation_finished)
	animationPlayer.play("intro")

func _on_intro_animation_finished(anim_name: StringName) -> void:
	if anim_name == "intro":
		var intro = Dialogic.start("0_Intro")
		add_child(intro)
		
		var tween = create_tween()
		tween.tween_property(intro_scene, "modulate", Color(1, 1, 1, 0), 1.5)
		tween.tween_callback(intro_scene.hide)

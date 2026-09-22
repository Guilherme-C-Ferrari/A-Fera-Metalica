extends Node2D

@export var animationPlayer : AnimationPlayer
@export var intro_scene: Control
@export var credits: Control

func _ready() -> void:
	animationPlayer.animation_finished.connect(_on_intro_animation_finished)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	animationPlayer.play("intro")

func _on_dialogic_signal(argument: String) -> void:
	if argument == "start_credits":
		play_credits()

func _on_intro_animation_finished(anim_name: StringName) -> void:
	if anim_name == "intro":
		var intro = Dialogic.start("0_Intro")
		
		var tween = create_tween()
		tween.tween_property(intro_scene, "modulate", Color(1, 1, 1, 0), 1.5)
		tween.tween_callback(intro_scene.hide)

func play_credits() -> void:
	animationPlayer.play("creditos")

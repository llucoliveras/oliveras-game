extends Control

@export var intro_zoom: int = 10
@export var intro_duration: float = 1.0

@onready var camera_2d: Camera2D = %Camera2D
@onready var combat_scene: Control = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_fade_in_intro()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _fade_in_intro():
	camera_2d.zoom = Vector2(intro_zoom, intro_zoom)
	combat_scene.modulate = Color.BLACK
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(combat_scene, "modulate", Color.WHITE, intro_duration)
	tween.parallel().tween_property(camera_2d, "zoom", Vector2.ONE, intro_duration/2)

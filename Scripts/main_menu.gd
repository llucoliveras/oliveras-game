extends CanvasLayer

const WORLD: Resource = preload("uid://dtsdinqdhoryw")

@onready var play_button: Button = %PlayButton
@onready var exit_button: Button = %ExitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.pressed.connect(_load_first_scene)
	exit_button.pressed.connect(get_tree().quit)
	
func _load_first_scene() -> void:
	get_tree().change_scene_to_packed(WORLD)

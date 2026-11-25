extends VBoxContainer

const DEFAULT_ENEMY: Enemy_Data = preload("uid://cwn08wcu22ibf")
const HEALTH_CHANGE_DURATION: float = 0.1 # How much it lasts from when the enemy is hurt until the healthbar updates to the new actual value
const HURT_ON_HEALTH_CHANGE_DELAY: float = 0.25 # How much delay is between the green bar update to the red bar update

@export var data: Enemy_Data

@onready var image: TextureRect = %Image
@onready var name_label: Label = %NameLabel
@onready var hurt_health_bar: ProgressBar = $CenterContainer/HurtHealthBar
@onready var current_health_bar: ProgressBar = $CenterContainer/CurrentHealthBar

var current_health: float
var health_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not data:
		printerr("NO ENEMY DATA WAS GIVEN")
		data = DEFAULT_ENEMY
	
	if data.image:
		image.texture = data.image
	if data.name:
		name_label.text = data.name
	if data.max_health:
		current_health = data.max_health
		current_health_bar.max_value = data.max_health
		current_health_bar.value = data.max_health
		hurt_health_bar.max_value = data.max_health
		hurt_health_bar.value = data.max_health
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var new_health := maxf(current_health - float(randi() % 15), 0.0)
		_on_health_changed(new_health)
		
func _on_health_changed(new_value: float) -> void:
	current_health = clampf(new_value, 0.0, current_health_bar.max_value)

	if health_tween and health_tween.is_valid():
		health_tween.kill()

	health_tween = create_tween()
	health_tween.set_ease(Tween.EASE_IN_OUT)
	health_tween.set_trans(Tween.TRANS_SINE)

	# 1. Animate the main health bar immediately
	health_tween.tween_property(current_health_bar, "value", current_health, HEALTH_CHANGE_DURATION)
	# 2. Wait for the delay, then animate the hurt bar to match
	health_tween.tween_interval(HURT_ON_HEALTH_CHANGE_DELAY)
	health_tween.tween_property(hurt_health_bar, "value", current_health, HEALTH_CHANGE_DURATION)
	
func _on_health_changed_timer_timeout() -> void:
	print("HELLO")
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(hurt_health_bar, "value", current_health_bar.value, HEALTH_CHANGE_DURATION)

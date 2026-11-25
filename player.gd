extends CharacterBody2D

const FLIP_COOLDOWN: float = 0.25
const SPRINT_MULTIPLIER: float = 2.0

@export var speed: float = 250.0

var time_since_last_flip: float = 0.0
var is_sprinting: bool = false

func _physics_process(delta: float) -> void:
	velocity = get_snapped_move_dir() * speed
	if is_sprinting:
		velocity *= SPRINT_MULTIPLIER
	move_and_slide()
	time_since_last_flip += delta
	if velocity != Vector2.ZERO and time_since_last_flip > FLIP_COOLDOWN:
		time_since_last_flip -= FLIP_COOLDOWN
		$Sprite2D.flip_h = not $Sprite2D.flip_h

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_SHIFT and not event.echo:
		if event.is_pressed():
			is_sprinting = true
		elif event.is_released():
			is_sprinting = false
	print(is_sprinting)

func get_snapped_move_dir(deadzone: float = 0.2) -> Vector2:
	var input_vec := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vec.length() < deadzone:
		return Vector2.ZERO

	var sector := roundi(input_vec.angle() / (PI / 4.0))
	var snapped_angle := sector * (PI / 4.0)
	return Vector2.from_angle(snapped_angle).normalized()

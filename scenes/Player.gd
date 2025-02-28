extends CharacterBody2D

@export var gravity = 300.0
@export var walk_speed = 200
@export var jump_speed = -300
@export var dash_speed = 400
@export var crouch_speed = 100

# Variabel tambahan untuk mekanika
var jump_count = 0
var max_jumps = 2
var is_crouching = false
var is_dashing = false
var run_tap_interval = 0.25
var last_right_tap_time = 0
var last_left_tap_time = 0

# Node AnimatedSprite2D
@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(delta):
	var direction = Vector2.ZERO
	# Gravitasi
	velocity.y += delta * gravity

	# Double Jump
	if is_on_floor():
		jump_count = 0
	if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps:
		velocity.y = jump_speed
		jump_count += 1

	# Crouching
	if Input.is_action_pressed("ui_down") and is_on_floor():
		is_crouching = true
	else:
		is_crouching = false

	# Dashing Right
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		if Input.is_action_just_pressed("ui_right"):
			if Time.get_ticks_msec() / 1000.0 - last_right_tap_time < run_tap_interval:
				is_dashing = true
			else:
				is_dashing = false

			last_right_tap_time = Time.get_ticks_msec() / 1000.0

	# Dashing Left
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		if Input.is_action_just_pressed("ui_left"):
			if Time.get_ticks_msec() / 1000.0 - last_left_tap_time < run_tap_interval:
				is_dashing = true
			else:
				is_dashing = false

			last_left_tap_time = Time.get_ticks_msec() / 1000.0

	# Kontrol gerakan apakah Dash atau Walk
	if direction != Vector2.ZERO:
		if is_dashing:
			if not is_crouching:
				velocity.x = direction.x * dash_speed
			else:
				velocity.x = direction.x * crouch_speed
		else:
			# Walk Left
			if Input.is_action_pressed("ui_left"):
				velocity.x = -walk_speed if not is_crouching else -crouch_speed
			# Walk Right
			elif Input.is_action_pressed("ui_right"):
				velocity.x = walk_speed if not is_crouching else crouch_speed
	else:
		velocity.x = 0

	# Fungsi Arah sprite dan animasi
	update_animation_and_direction()

	move_and_slide()

	# Jika player jatuh ke bawah layar, restart level
	if position.y > get_viewport_rect().size.y:
		get_tree().reload_current_scene()


func update_animation_and_direction():
	# Arah sprite
	# Menghadap kiri
	if velocity.x < 0:
		animated_sprite.flip_h = true
	# Menghadap kanan
	elif velocity.x > 0:
		animated_sprite.flip_h = false

	# Animasi
	if not is_on_floor():
		animated_sprite.play("Jump")
	elif is_crouching:
		animated_sprite.play("Crouch")
	elif velocity.x != 0:
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")

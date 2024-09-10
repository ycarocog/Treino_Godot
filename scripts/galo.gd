extends CharacterBody2D
@onready var _animated_sprite = $AnimatedSprite2D
@onready var colision = $ColisionPlayer
# Direção para onde o player está olhando
enum State{
	LEFT,
	RIGHT
}

enum Movement{
	WALKING,
	IDLE
}

var speed:int 

var doble_jump:int = 2

var current_state = State.RIGHT
var current_movement = Movement.IDLE
var direction : Vector2 = Vector2()
var jump_time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func read_input():
	# Movimento
	# Muda a animação e acelera o jogador na direção que está sendo apertada
	# Tambem liga a caixa de interação respectiva
	velocity = Vector2()
	
	if Input.is_action_pressed("left"):
		velocity.x -= 1 + speed
		direction = Vector2(1 + speed, 0)
		current_state = State.LEFT
		current_movement = Movement.WALKING
	elif Input.is_action_pressed("right"):
		velocity.x += 1 + speed
		direction = Vector2(1 + speed, 0)
		current_state = State.RIGHT
		current_movement = Movement.WALKING
	else:
		current_movement = Movement.IDLE
	if jump_time <= 0:
		velocity.y += 1
		direction += Vector2(0, 0)
		if is_on_floor():
			doble_jump = 2
	else:
		velocity.y = -1
		jump_time -= 1
		direction += Vector2(0, -15)
		
	if Input.is_action_just_pressed("jump"):
		if jump_time == 0 and doble_jump > 0:
			doble_jump -= 1
			jump_time = 15
	if current_movement == Movement.WALKING:
		match(current_state):
			State.RIGHT:
				_animated_sprite.play("walk_right")
			State.LEFT:
				_animated_sprite.play("walk_left")
	else:
		# Se o jogador não está se movendo mostra sprite de parado na direção atual
		match(current_state):
			State.RIGHT:
				_animated_sprite.play("idle_right")
			State.LEFT:
				_animated_sprite.play("idle_left")
					
			
				
			
	# Acelera o jogador, se ele segurar shift acelera mais
	if Input.is_action_pressed("run"):
		speed = 1
	else :
		speed = 0
	#velocity = velocity.normalized()
	velocity = velocity * 230
	
	move_and_slide()
	

func _physics_process(_delta):
	read_input()

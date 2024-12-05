extends Marker3D

@export var button_object: PackedScene

@export var cols: int = 6
@export var rows: int = 3

@export var first_sample: AudioStreamWAV
@export var second_sample: AudioStreamWAV
@export var third_sample: AudioStreamWAV

@export var sequence: Array
@export var samples: Array
@export var players: Array

@export var current_step: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_sequence_array()
	instatiate_buttons()
	add_players()
	add_samples()
	
func add_samples() -> void:
	samples.append(first_sample)
	samples.append(second_sample)
	samples.append(third_sample)
	

func add_players() -> void:
	for i in range(50):
		var asp = AudioStreamPlayer.new()
		add_child(asp)
		players.push_back(asp)
		
func create_sequence_array() -> void:
	# Create an array that holds an array
	for i in range(rows):
		var row = []
		for j in range(cols):
			row.append(false)
		sequence.append(row)

func _on_timer_timeout() -> void:
	# When the timer times out
	play_step(current_step)
	current_step = (current_step + 1) % cols
	print(current_step)

func instatiate_buttons():
	# Create buttons
	
	var space = 0.16
	var vertical_space = 0.12
	for row in range(rows):
		for col in range(cols):
			# Create button
			var button = button_object.instantiate()
			
			# Get position
			var pos = Vector3(
				col * space, 
				0 -(row * vertical_space), 
				0
			)
			
			# Set position and rotation
			button.position = pos
			button.rotation = rotation
			
			button.toggle_changed.connect(toggle.bind(row, col))
			
			# Add child
			add_child(button)

func play_step(col):
	var space = 0.16
	
	# Get position
	var pos = Vector3(
		col * space, 
		-0.36, 
		0
	)

	$TimerCube.position = pos
	
	for row in range(rows):
		if sequence[row][col]:
			play_sample(0, row)

var asp_index = 0
func play_sample(e, i):
	var player: AudioStream = samples[i]
	var asp = players[asp_index]
	asp.stream = player
	asp.play()
	asp_index = (asp_index + 1) % players.size()

func toggle(row, col):
	sequence[row][col] = ! sequence[row][col]
	play_sample(0, row)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Area3D

@export var unselected_colour: Color = Color(58,51,51)
@export var highlighted_colour: Color = Color(213, 223, 229)
@export var selected_colour: Color = Color(240, 58, 71)

var mat: StandardMaterial3D
var toggled: bool = false
var hovered: bool = false

var row: int = 0
var col: int = 0

signal toggle_changed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mat = StandardMaterial3D.new()
	$MeshInstance3D.set_surface_override_material(0, mat)
	mat.albedo_color = unselected_colour
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_material()

func set_material() -> void:
	# If the button is hovered over
	if hovered:
		mat.albedo_color = highlighted_colour
		return
	
	# If the button is toggled
	if toggled:
		mat.albedo_color = selected_colour
		return
	
	# Default colour
	mat.albedo_color = unselected_colour

func _on_mouse_entered() -> void:
	hovered = !hovered

func _on_mouse_exited() -> void:
	hovered = !hovered

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	# When Pressed
	if Input.is_action_just_released("mouse_clicked"):
		toggle_changed.emit()

func set_row_and_col(row, col) -> void:
	self.row = row
	self.col = col

func get_row_col_and_toggle() -> Array:
	var arr = []
	arr.append(row)
	arr.append(col)
	arr.append(toggled)
	
	return arr


func _on_toggle_changed() -> void:
	toggled = ! toggled

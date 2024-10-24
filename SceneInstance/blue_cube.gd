extends Node3D  # Assuming this is attached to the Moving Cube

@export var speed: float = 1.0
@export var destroy_distance: float = 1.0
@export var max_distance: float = 20.0  # The maximum distance to move past the player before being removed
var player_position: Vector3
var original_size: Vector3

@onready var xr_interface = XRServer.find_interface("OpenXR")  # Access the OpenXR interface
@onready var player = $Player  # Change this to your actual player or camera node
@onready var area = $Area3D  # Reference to the Area3D node attached to the cube

func _ready():    
	# Connect to the 'on_pose_recentered' signal
	if xr_interface != null:
		xr_interface.connect("on_pose_recentered", Callable(self, "_on_pose_recentered"))
	else:
		print("OpenXR interface not found!")

	# Set the original size based on the current size of the cube mesh
	var mesh_instance = $MeshInstance3D # Ensure you have a MeshInstance3D attached to the cube
	if mesh_instance != null:
		original_size = mesh_instance.mesh.get_aabb().size
	else:
		print("MeshInstance3D not found, cannot get size!")

	# Get the player's position (assuming XR origin)
	if has_node("/root/XROrigin3D"):
		player_position = get_node("/root/XROrigin3D").global_transform.origin
	else:
		print("XROrigin3D not found in the scene!")
		return

	# Connect the area_entered signal to detect collisions with the sword
	if area != null:
		area.connect("area_entered", Callable(self, "_on_area_3d_area_entered"))
	else:
		print("Area3D not found, unable to connect area_entered signal.")

func _process(delta):
	# Move the cube towards the player
	var direction_to_player = (player_position - global_position).normalized()
	global_position += direction_to_player * speed * delta

	# Allow the cube to continue moving past the player
	if global_transform.origin.distance_to(player_position) < destroy_distance:
		# If the cube gets close enough to the player, continue moving forward without stopping
		global_position += direction_to_player * speed * delta
		print("Cube is close to the player, continuing to move.")

	# If the cube has moved past a certain maximum distance, remove it from the scene
	if global_transform.origin.distance_to(player_position) > max_distance:
		queue_free()  # Destroy the cube
		print("Cube surpassed the maximum distance and was removed.")

func split_cube():
	queue_free()

# This function is called when an area (e.g., the sword's collision area) enters the cube's area

# This function is called when the "Oculus" button is pressed, and pose is recentered
func _on_pose_recentered() -> void:
	print("Pose recentered! Repositioning the player to face the cube.")

	# Calculate the direction from the player's current position to the cube
	var player_position = player.global_transform.origin
	var direction_to_cube = (global_transform.origin - player_position).normalized()

	# Set the player's global_transform to face the cube
	var new_transform = player.global_transform
	new_transform.origin = global_transform.origin - (direction_to_cube * 5)  # Position the player 5 units away from the cube
	new_transform.basis = Basis(direction_to_cube)  # Adjust player's orientation to face the cube

	# Apply the new transform to the player
	player.global_transform = new_transform

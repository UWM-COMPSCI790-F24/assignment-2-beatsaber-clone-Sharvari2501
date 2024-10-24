extends Node3D  # Assuming this is attached to the Moving Cube

@export var speed: float = 2.0
@export var destroy_distance: float = 1.0
var player_position: Vector3
var original_size: Vector3
@export var z_threshold: float = -10.0 

@onready var xr_interface = XRServer.find_interface("OpenXR")  # Access the OpenXR interface
@onready var player = $Player  # Change this to your actual player or camera node


func _ready():
	# Connect to the 'on_pose_recentered' signal
	if xr_interface != null:
		xr_interface.connect("on_pose_recentered", Callable(self, "_on_pose_recentered"))
	else:
		print("OpenXR interface not found!")

	# Set the original size based on the current size of the cube mesh
	var mesh_instance = $MeshInstance3D  # Ensure you have a MeshInstance3D attached to the cube
	if mesh_instance != null:
		original_size = Vector3(0.5, 0.5, 0.5) 
	else:
		print("MeshInstance3D not found, cannot get size!")

	# Get the player's position (assuming XR origin)
	if has_node("/root/XROrigin3D"):
		player_position = get_node("/root/XROrigin3D").global_transform.origin
	else:
		print("XROrigin3D not found in the scene!")
		return

func _process(delta):
	# Move the cube towards the player
	global_position.z -= speed * delta

	# Check if the cube is close enough to the player
	if global_transform.origin.distance_to(player_position) < destroy_distance:
		split_cube()  # Call the function to split the cube
	# Check if the cube has passed the user and reached the z threshold
	if global_position.z < z_threshold:
		queue_free()  # Destroy the cube without playing the sound


func split_cube():
	queue_free()

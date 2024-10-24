extends Node3D

var xr_interface: XRInterface
var right_laser_on = false
var left_laser_on = false
@onready var right_laser=$RightController/MeshInstance3D
@onready var left_laser=$LeftController/MeshInstance3D
@onready var right_laser_ray= $RightController/MeshInstance3D/RayCast3D
@onready var left_laser_ray= $LeftController/MeshInstance3D/RayCast3D

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		
		# Connect the 'xr_pose_recentered' signal to the recenter function
		xr_interface.connect("xr_pose_recentered", Callable(self, "_on_pose_recentered"))

		# Turn off v-sync for VR
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Enable XR in the main viewport
		get_viewport().use_xr = true

	else:
		print("OpenXR not initialized, please check if your headset is connected")

func _process(delta: float) -> void:
	pass

# Function to handle recentering when the system-level button is pressed (e.g., Oculus button)
func _on_pose_recentered():
	print("Pose recentered!")
	# Get the global position of the flying cube
	var cube_position = $boxmove.global_transform.origin

	# Update player's position to be centered relative to the cube
	var player_transform = global_transform
	player_transform.origin = cube_position + Vector3(0, 1.5, -3)

	# Calculate direction from player to the cube and rotate player to face it
	var direction_to_cube = (cube_position - player_transform.origin).normalized()
	player_transform.basis = Basis(Vector3.UP, direction_to_cube.angle_to(Vector3.FORWARD))

	# Apply the new transform to the player
	global_transform = player_transform

func _on_right_controller_button_pressed(name: String) -> void:
	if name == "ax_button":
		# Toggle the right laser visibility and interaction
		right_laser_on = !right_laser_on  # Toggle the state (on/off)
		_toggle_laser(right_laser, right_laser_ray, right_laser_on)


func _on_left_controller_button_pressed(name: String) -> void:
	if name == "ax_button":
		# Toggle the left laser visibility and interaction
		left_laser_on = !left_laser_on  # Toggle the state (on/off)
		_toggle_laser(left_laser, left_laser_ray, left_laser_on) # Replace with function body.
		
func _toggle_laser(laser_mesh: MeshInstance3D, laser_raycast: RayCast3D, laser_on: bool):
	laser_mesh.visible = laser_on  # Toggle visibility of the laser sword
	laser_raycast.enabled = laser_on  # Enable or disable interaction (RayCast3D)
	
	if laser_on:
		print("Laser is ON")
		laser_raycast.cast_to = Vector3(0, 0, -1) * 1.0  # Cast 1 meter in the negative Z direction
	else:
		print("Laser is OFF")




func _on_world_environment_pose_recentered() -> void:
	pass # Replace with function body.

extends WorldEnvironment

signal pose_recentered

@onready var red_cube_spawner = $"/root/Main/RedCubeSpawner"  # Update this path to match your red cube spawner node
@onready var blue_cube_spawner = $"/root/Main/BlueCubeSpawner"  # Update this path to match your blue cube spawner node
@onready var red_ray_cast = $"LeftController/MeshInstance3D/RayCast3D"  # Update this path to match the red ray cast node
@onready var blue_ray_cast = $"RightController/MeshInstance3D/RayCast3D"  # Update this path to match the blue ray cast node

func _ready() -> void:
	# Connect the pose recentered signal
	connect("pose_recentered", Callable(self, "_on_pose_recentered"))

func _on_pose_recentered() -> void:
	# Logic to handle pose recentering
	print("Pose recentered signal received.")
	center_on_hmd()  # Custom function to recenter the view if needed

	# Trigger cube spawning for both red and blue spawners
	if red_cube_spawner != null:
		red_cube_spawner.spawn_cube()  # Call the spawn function for red cubes
		print("Spawned a new red cube after pose recentering.")
	else:
		print("Red cube spawner not found in the scene!")

	if blue_cube_spawner != null:
		blue_cube_spawner.spawn_cube()  # Call the spawn function for blue cubes
		print("Spawned a new blue cube after pose recentering.")
	else:
		print("Blue cube spawner not found in the scene!")

func center_on_hmd() -> void:
	# Example implementation for recentering the view
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface != null:
		xr_interface.recenter_pose()  # Call the OpenXR recentering function
		print("XR Pose has been recentered.")
	else:
		print("XR Interface not found!")

func _process(delta: float):
	# Check for interactions with red and blue cubes using ray casts
	if red_ray_cast != null and red_ray_cast.is_colliding():
		var red_hit = red_ray_cast.get_collider()
		if red_hit != null and red_hit.is_in_group("red_cubes"):
			print("Red cube hit detected!")
			red_hit.queue_free()  # Example interaction: remove the red cube

	if blue_ray_cast != null and blue_ray_cast.is_colliding():
		var blue_hit = blue_ray_cast.get_collider()
		if blue_hit != null and blue_hit.is_in_group("blue_cubes"):
			print("Blue cube hit detected!")
			blue_hit.queue_free()  # Example interaction: remove the blue cube

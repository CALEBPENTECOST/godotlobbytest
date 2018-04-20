extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_FindGamesButton_pressed():
	# The user wishes to search for games
	var gameID = get_node("Panel_findGames/FindGameID").text
	var gameAPI = get_node("Panel_findGames/FindGameAPI").text
	var jsonResponse = get_node("io_autometa_lobby").findGames(gameID, gameAPI)
	get_node("Panel_findGames/FoundGames").text = String(jsonResponse)
	pass


func _on_HostGameButton_pressed():
	var gameID = get_node("Panel_hostGame/HostGameId").text
	var gameAPI = get_node("Panel_hostGame/HostGameAPI").text
	var ipAddr = get_node("Panel_hostGame/HostSpecificInfo").text
	var port = get_node("Panel_hostGame/HostGamePort").text
	var nickname = get_node("Panel_hostGame/HostGameNickName").text
	var hidden = get_node("Panel_hostGame/CheckBox").pressed
	
	var jsonResponse = get_node("io_autometa_lobby").createGame(gameID, gameAPI, ipAddr, port, nickname, hidden)
	get_node("Panel_hostGame/HostGameResponse").text = String(jsonResponse)
	pass


func _on_FindGameButton_pressed():
	var gameID = get_node("Panel_directFind/FindGameID").text
	var gameAPI = get_node("Panel_directFind/FindGameAPI").text
	var nickname = get_node("Panel_directFind/FindGameLobby").text
	
	var jsonResponse = get_node("io_autometa_lobby").getGameInfo(gameID, gameAPI, nickname)
	get_node("Panel_directFind/PublicGameResponse").text = String(jsonResponse)
	pass


func _on_JoinGameButton_pressed():
	var gameID = get_node("Panel_joinGame/JoinGameID").text
	var gameAPI = get_node("Panel_joinGame/JoinGameVersion").text
	var ipAddr = get_node("Panel_joinGame/JoinGameIP").text
	var port = get_node("Panel_joinGame/JoinGamePort").text
	var nickname = get_node("Panel_joinGame/JoinGameLobby").text
	
	var jsonResponse = get_node("io_autometa_lobby").joinGame(gameID, gameAPI, ipAddr, port, nickname)
	get_node("Panel_joinGame/JoinGameResponse").text = String(jsonResponse)
	pass


func _on_LockGameButton_pressed():
	var gameID = get_node("Panel_lockGame/CloseGameID").text
	var gameAPI = get_node("Panel_lockGame/CloseGameVersion").text
	var ipAddr = get_node("Panel_lockGame/CloseGameIP").text
	var port = get_node("Panel_lockGame/CloseGamePort").text
	var nickname = get_node("Panel_lockGame/CloseGameLobby").text
	
	var jsonResponse = get_node("io_autometa_lobby").closeGame(gameID, gameAPI, ipAddr, port, nickname)
	get_node("Panel_lockGame/CloseGameResponse").text = String(jsonResponse)
	pass

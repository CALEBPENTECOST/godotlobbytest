extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var LobbyServer = "https://xp92sqtki2.execute-api.us-west-2.amazonaws.com"
export var Port = -1

var isConnected = false
var kErrorString = "httpError"
var kURLPrefix = "/deploy/"
var kRequestHeader = [
        "Content-Type: application/json"
]

var netClient

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	netClient = HTTPClient.new()
	pass

func disconnect():
	if isConnected == false:
		return
	
	netClient.close()
	netClient = HTTPClient.new()
	isConnected = false

func ensureConnected():
	if isConnected == true:
		netClient.close()
		isConnected = false
	
	# start a connection
	var err = netClient.connect_to_host(LobbyServer, Port, true, true)
	assert(err == OK)
	
	# Wait until resolved and connected
	var maxAttempts = 50
	var attempts = 0
	while netClient.get_status() == HTTPClient.STATUS_CONNECTING or netClient.get_status() == HTTPClient.STATUS_RESOLVING:
		if attempts > maxAttempts:
			return false
		
		netClient.poll()
		print("Connecting...")
		OS.delay_msec(100)
		attempts = attempts + 1
	
	# ensure connection
	var connectStatus = netClient.get_status()
	assert(connectStatus == HTTPClient.STATUS_CONNECTED) # Could not connect
	
	# Done!
	isConnected = true
	pass

func postJSONMessage(url, json):
	if ensureConnected() == false:
		return kErrorString
	
	netClient.request(HTTPClient.METHOD_POST, "" + kURLPrefix + url, kRequestHeader, json)
	
	while (netClient.has_response() == false):
		OS.delay_msec(100)
		netClient.poll()
	
	var m1 = netClient.read_response_body_chunk()
	var message = m1.get_string_from_ascii()
	
	return message

# Attempts to find games
func findGames(sID, sAPI):
	# Create a message variant to JSON-ify
	var message = {}
	message.id = sID
	message.api = sAPI
	var json = JSON.print(message)
	
	# attempt to communicate
	var response = postJSONMessage("Search", json)
	return response

	# Attempts to create a game
func createGame(sID, sAPI, sIpAddr, sPort, sNickname, sIsHidden):
	# Create a message variant to JSON-ify
	var message = {}
	message.owner = {}
	message.owner.ip = sIpAddr
	message.owner.port = sPort
	message.owner.game = {}
	message.owner.game.id = sID
	message.owner.game.api = sAPI
	message.owner.nickName = sNickname
	message.hidden = sIsHidden
	var json = JSON.print(message)
	
	# attempt to communicate
	var response = postJSONMessage("Create", json)
	return response
	
func getGameInfo(sGameID, sGameAPI, sNickname):
	# Create a message variant to JSON-ify
	var message = {}
	message.game = {}
	message.game.id = sGameID
	message.game.api = sGameAPI
	message.lobbyId = sNickname
	var json = JSON.print(message)
	
	# attempt to communicate
	var response = postJSONMessage("Read", json)
	return response
	
func joinGame(gameID, gameAPI, ipAddr, port, nickname):
	# Create a message variant to JSON-ify
	var message = {}
	message.client = {}
	message.client.ip = ipAddr
	message.client.port = port
	message.client.game = {}
	message.client.game.id = gameID
	message.client.game.api = gameAPI
	message.lobbyId = nickname
	var json = JSON.print(message)
	
	# attempt to communicate
	var response = postJSONMessage("Join", json)
	return response

func closeGame(gameID, gameAPI, ipAddr, port, nickname):
	# Create a message variant to JSON-ify
	var message = {}
	message.client = {}
	message.client.ip = ipAddr
	message.client.port = port
	message.client.game = {}
	message.client.game.id = gameID
	message.client.game.api = gameAPI
	message.lobbyId = nickname
	var json = JSON.print(message)
	
	# attempt to communicate
	var response = postJSONMessage("Lock", json)
	return response

# End of file

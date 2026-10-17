extends Node
var gq1 = [ "Qatar" , "Ecuador" , "Senegal" , "Holland"]
var gq2 = [ "Engurland" , "Iran" , "USandA" , "Wales"]
var gq3 = [ "Argentina" , "Saudi Arabia" , "Mexico" , "Polska"]
var gq4 = [ "LaFrance" , "Australia" , "Danmark" , "Tunisia"]
var gq5 = [ "Espana" , "Costa Rica" , "Germany" , "Japan"]
var gq6 = [ "Belgium" , "Canadia" , "Morocco" , "Croatia"]
var gq7 = [ "Brasil" , "Serbia" , "Switzerland" , "Cameroon"]
var gq8 = [ "Portugal" , "Ghana" , "Uruguay" , "South Korea"]
var gr1 = [ "Uruguay" , "Ukraine" , "Saudi Arabia" , "Egypt"]
var gr2 = [ "Espana" , "Portugal" , "Iran" , "Morocco"]
var gr3 = [ "LaFrance" , "Danmark" , "Australia" , "Peru"]
var gr4 = [ "Croatia" , "Argentina" , "Nigeria" , "Iceland"]
var gr5 = [ "Brasil" , "Switzerland" , "Serbia" , "Costa Rica"]
var gr6 = [ "Sweden" , "Mexico" , "South Korea" , "Germany"]
var gr7 = [ "Engurland" , "Belgium" , "Tunisia" , "Panama"]
var gr8 = [ "Colombia" , "Japan" , "Senegal" , "Polska"]
var ga1 = [ "Mexico" , "Cameroon" , "Croatia" , "Brasil"]
var ga2 = [ "Chile" , "Holland" , "Espana" , "Australia"]
var ga3 = [ "Ivory Coast" , "Japan" , "Greece" , "Colombia"]
var ga4 = [ "Italia" , "Engurland" , "Costa Rica" , "Uruguay"]
var ga5 = [ "Honduras" , "LaFrance" , "Ecuador" , "Switzerland"]
var ga6 = [ "Nigeria" , "Iran" , "Argentina" , "Bosnia"]
var ga7 = [ "USandA" , "Ghana" , "Portugal" , "Germany"]
var ga8 = [ "South Korea" , "Ukraine" , "Algeria" , "Belgium"]
var gw1 = [ "New Zealand W" , "Norway W" , "Philippines W" , "Switzerland W"]
var gw2 = [ "Australia W" , "Canada W" , "Eire W" , "Nigeria W"]
var gw3 = [ "Costa Rica W" , "Japan W" , "Spain W" , "Zambia W"]
var gw4 = [ "China W" , "Denmark W" , "England W" , "Haiti W"]
var gw5 = [ "Holland W" , "Portugal W" , "USandA W" , "Vietnam W"]
var gw6 = [ "Brasil W" , "France W" , "Jamaica W" , "Panama W"]
var gw7 = [ "Argentina W" , "Italia W" , "South Africa W" , "Sweden W"]
var gw8 = [ "Colombia W" , "Germany W" , "Morocco W" , "South Korea W"]
var g1
var g2
var g3
var g4
var g5
var g6
var g7
var g8
var cup = 4
var groups = []
var balls = []
var cround : PoolVector2Array
var playertie = 0
var tourneyName = "Global Cup 2022"
var cr = 0
var roundp = 0
var knockout = null
var t = []
var justplayed = false
var knockoutStage = false
var year = 2022
func _setCup( var c) :
	match c :
		0 :
			g1 = gq1
			g2 = gq2
			g3 = gq3
			g4 = gq4
			g5 = gq5
			g6 = gq6
			g7 = gq7
			g8 = gq8
			year = 2022
		1 :
			g1 = gr1
			g2 = gr2
			g3 = gr3
			g4 = gr4
			g5 = gr5
			g6 = gr6
			g7 = gr7
			g8 = gr8
			year = 2018
		2 :
			g1 = ga1
			g2 = ga2
			g3 = ga3
			g4 = ga4
			g5 = ga5
			g6 = ga6
			g7 = ga7
			g8 = ga8
			year = 2014
		4 :
			g1 = gw1
			g2 = gw2
			g3 = gw3
			g4 = gw4
			g5 = gw5
			g6 = gw6
			g7 = gw7
			g8 = gw8
			year = 2023
func findTeams( var g) :
	for i in range( 0 , 4) :
		for j in range( Global.teams.size()) :
			if Global.teams[ j].teamname == g[ i] :
				t[ i] = j
				break
		if t[ i] == 0 :
			print( "couldn't find team " , g[ i])
func findTeam( var g , var name) :
	for i in range( 0 , 4) :
		if name == g[ i] :
			return true
	return false
func _qualified( var tname) :
	if findTeam( g1 , tname) :
		return true
	elif findTeam( g2 , tname) :
		return true
	elif findTeam( g3 , tname) :
		return true
	elif findTeam( g4 , tname) :
		return true
	elif findTeam( g5 , tname) :
		return true
	elif findTeam( g6 , tname) :
		return true
	elif findTeam( g7 , tname) :
		return true
	elif findTeam( g8 , tname) :
		return true
	return false
func initGroups( var i , var g) :
	findTeams( g)
	var group = load( "res://Scenes/WCGroupTournament.tscn").instance()
	groups.append( group)
	group._initLeague( - 1 , t[ 0] , t[ 1] , t[ 2] , t[ 3] , i)
func _initCup() :
	t.resize( 4)
	initGroups( 1 , g1)
	initGroups( 2 , g2)
	initGroups( 3 , g3)
	initGroups( 4 , g4)
	initGroups( 5 , g5)
	initGroups( 6 , g6)
	initGroups( 7 , g7)
	initGroups( 8 , g8)
func _setupPlayerTie() :
	for i in range( 0 , 8) :
		groups[ i]._isPlayerTie()
func _gamePlayed( var score) :
	if cr < 3 :
		for i in range( 0 , 8) :
			groups[ i]._gamePlayed( score)
	else :
		knockoutGamePlayed( score)
	cr += 1
func _rotateFixtures() :
	for i in range( 0 , 8) :
		groups[ i]._rotateFixtures()
func _knockoutStage() :
	knockoutStage = true
	cround.resize( 16)
	balls.resize( 16)
	var j = 0
	for i in range( 0 , 8) :
		balls[ j] = groups[ i]._getWinner()
		balls[ j + 8] = groups[ i]._getSecond()
		j += 1
func knockoutGamePlayed( var s1) :
	var s = 0
	var e = 8
	var t = 0
	match roundp :
		1 :
			s = 8
			e = 12
			t = 16
		2 :
			s = 12
			e = 14
			t = 24
		3 :
			s = 14
			e = 15
			t = 28
	for i in range( s , e) :
		if i == playertie :
			cround[ playertie] = Vector2( s1.x , s1.y)
		else :
			cround[ i] = Vector2( floor( rand_range( 0 , 4)) , floor( rand_range( 0 , 4)))
			if cround[ i].x == cround[ i].y :
				if rand_range( 0 , 1) < 0.6 :
					cround[ i].x += 1
				else :
					cround[ i].y += 1
	roundp += 1
	updateCup( s , e , t)
func updateCup( var s , var e , var t) :
	for i in range( s , e) :
		if cround[ i].x > cround[ i].y :
			balls.append( balls[ t])
		else :
			balls.append( balls[ t + 1])
		t += 2
		cround.append( Vector2.ZERO)
func _loadState() :
	var save_game = File.new()
	var fname = "user://globalcup.save"
	if Global.tType == 3 :
		fname = "user://wglobalcup.save"
	if not save_game.file_exists( fname) :
		return false
	save_game.open( fname , File.READ)
	Global.tTeam = parse_json( save_game.get_line())
	print( Global.tTeam)
	cr = parse_json( save_game.get_line())
	print( cr)
	for i in range( 0 , 8) :
		groups[ i]._loadState( save_game)
	if cr > 2 :
		knockoutStage = true
		balls = parse_json( save_game.get_line())
		cround = save_game.get_var()
		roundp = int( parse_json( save_game.get_line()))
	save_game.close()
	return true
func _saveState() :
	var save_game = File.new()
	var fname = "user://globalcup.save"
	if Global.tType == 3 :
		fname = "user://wglobalcup.save"
	save_game.open( fname , File.WRITE)
	save_game.store_line( to_json( Global.tTeam))
	save_game.store_line( to_json( cr))
	for i in range( 0 , 8) :
			groups[ i]._saveState( save_game)
	if cr > 2 :
		save_game.store_line( to_json( balls))
		save_game.store_var( cround)
		save_game.store_line( to_json( roundp))
	save_game.close()
	print( "saved")
func _continueCup( var cp) :
	print( "restoring tournament")
	_initCup()
	var res = _loadState()
	if not res :
		return false
	print( "restoring tournament done")
	return true

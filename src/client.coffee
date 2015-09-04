if process.argv.length < 3
    console.log "Insufficient parameters."
    process.exit 0


socketIoClient = require('socket.io-client')

protocol = 'http'
host = '127.0.0.1'
port = '8050'
address = "#{protocol}://#{host}:#{port}"

cliId = process.argv[2]

optionSocket =
    reconnect: true
    forceNew: true
    secure: true

numberReq = 0
countDone = 0

translateMilisecondTStandarHour = (diff) ->
    return {
        hours: Math.floor(diff / (1000 * 60 * 60))
        mins: Math.floor(diff / (1000 * 60))
        secs: Math.floor(diff / 1000)
    }

socket = socketIoClient.connect address, optionSocket

dateInit = new Date()

socket.on 'connect', ->
    console.log '[onConnect] - Connected'

    for [0...10000]
        numberReq++
        socket.emit 'myEvent', socket.id, {id: cliId, data: ':P', numberReq: numberReq}

    # Emitted "myEvent"

socket.on 'event', (data) ->
    console.log '[onEvent] - ', data

socket.on 'disconnected', (data) ->
    # [onDisconnection]
    socket.emit 'disconnect'

    dateEnd = new Date()
    dateMillisecond = dateEnd.getTime() - dateInit.getTime()
    hour = translateMilisecondTStandarHour dateMillisecond
    console.log 'total: ', hour
    console.log 'dateMillisecond: ', dateMillisecond
    process.exit 0

socket.on 'done', =>
    countDone++
    # [onDone] - countDone
    if countDone is 10000
        socket.emit 'shutdown', socket.id, {id: cliId, data: ':P'}
        console.log '[onConnect] - Emitted "shutdown" '
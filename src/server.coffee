app = require('express')()
server = require('http').Server(app)
io = require('socket.io')(server)

server.listen 8050

app.get '/', (req, res) ->
    res.sendfile __dirname + '/index.html'
    return

dateInit = new Date()

translateMilisecondTStandarHour = (diff) ->
    return {
        hours: Math.floor(diff / (1000 * 60 * 60))
        mins: Math.floor(diff / (1000 * 60))
        secs: Math.floor(diff / 1000)
    }

io.on 'connection', (socket) ->

    socket.emit 'event', hello: 'world'

    socket.on 'myEvent', (from, data) ->
        socket.emit 'done'
        # Emitted done'
        return

    socket.on 'shutdown', (from, data) ->
        console.log '[shutdown] ================'
        socket.emit 'disconnected'
#        socket.disconnect()  # or depends of sockets subscritors

        dateEnd = new Date()
        dateMillisecond = dateEnd.getTime() - dateInit.getTime()
        hour = translateMilisecondTStandarHour dateMillisecond
        console.log 'total: ', hour
        console.log 'dateMillisecond: ', dateMillisecond
        return
import 'package:band_name/models/band_model.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
    OnLine,
    OffLine,
    Connecting,
}

class SocketService with ChangeNotifier{
    ServerStatus _serverStatus = ServerStatus.Connecting;
    IO.Socket _socket;
    List<Band> _bands = [];

    SocketService(){
        this._initConfig();
    }

    ServerStatus get serverStatus => this._serverStatus;
    IO.Socket get socket => this._socket;
    // Function get emit => this._socket.emit;
    List<Band> get bands => this._bands;

    void _initConfig(){
        _socket = IO.io('http://localhost:3000/', {
            'transports': ['websocket'],
            'autoConnect': true,
        });
        _socket.on('connect', (_){
            _serverStatus = ServerStatus.OnLine;
            notifyListeners();
        });

        _socket.on('active-bands', (payload){
            this._bands = (payload as List).map((band) =>Band.fromMap(band)).toList();
            notifyListeners();
        });

        _socket.on('disconnect', (_){
            _serverStatus = ServerStatus.OffLine;
            notifyListeners();
        });
    }

    void addBand(String name){
        _socket.emit('add-band', {'name': name});
    }
    void voteBand(String id){
        _socket.emit('vote-band', {'id': id});
    }
    void deleteBand(String id){
        _socket.emit('delete-band', {'id': id});
    }
}
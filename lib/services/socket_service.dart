import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    this._socket = IO.io('https://flutter-socket-server-jpdm.herokuapp.com/', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    this._socket.onConnect((_) {
      print('connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      print('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    /*this._socket.on('nuevo-mensaje', (payload) {
      print('Mensaje: $payload');
    });*/
  }
}

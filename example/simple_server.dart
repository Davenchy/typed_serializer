import 'dart:io';
import 'dart:typed_data';

import 'package:typed_serializer/typed_serializer.dart';

class SimpleServer with TypedSerializer<Uint8List> {
  SimpleServer(this.socket);
  final Socket socket;

  static Future<SimpleServer> connect(
    InternetAddress address,
    int port,
  ) async {
    final socket = await Socket.connect(address, port);
    return SimpleServer(socket);
  }

  void send(Uint8List bytes) => socket.add(bytes);

  void sendObject<T>(T object) {
    final definition = findObjectDefinition<T>();
    if (definition == null) {
      throw Exception('No definition found for type $T');
    }

    final serializedObject = definition.serialize(object);
    send(serializedObject);
  }

  Stream<Uint8List> get stream => socket.asBroadcastStream();

  Stream<T> filteredStream<T>() {
    final definition = findObjectDefinition<T>();
    if (definition == null) {
      throw Exception('No definition found for type $T');
    }

    return stream.where(definition.detect).map<T>(definition.deserialize);
  }
}

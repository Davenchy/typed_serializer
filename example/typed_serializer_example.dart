import 'dart:io';

import 'item.dart';
import 'simple_server.dart';

Future<void> main() async {
  final server = await SimpleServer.connect(InternetAddress.loopbackIPv4, 8080);

  server.createObjectDefinition<Item>(
    serialize: (object) => object.toBytes(),
    deserialize: (bytes) => Item.fromBytes(bytes),
    detect: (data) => data.length >= 2 && data.length == 2 + data[1],
  );

  server.filteredStream<Item>().listen((item) {
    print('received item: $item');
  });

  final item = Item(55, 'my item');
  server.sendObject(item);
}

import 'dart:io';

import 'item.dart';
import 'simple_server.dart';

Future<void> main() async {
  final server = await SimpleServer.connect(InternetAddress.loopbackIPv4, 8080);

  server.createObjectDefinition<Item>(
    (object) => object.toBytes(),
    (bytes) => Item.fromBytes(bytes),
    (data) => data.length >= 2 && data.length == 2 + data[1],
  );

  server.listen<Item>().listen((item) {
    print('received item: $item');
  });

  final item = Item(55, 'my item');
  server.sendObject(item);
}

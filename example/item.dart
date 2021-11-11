import 'dart:typed_data';

class Item {
  const Item(this.id, this.name)
      : assert(id >= 0 && id < 255, 'id must be in range [0, 255]'),
        assert(
          name.length <= 20,
          'maximum name length is 20 character',
        );

  final int id;
  final String name;

  factory Item.fromBytes(Uint8List bytes) {
    final id = bytes[0];
    final nameLength = bytes[1];
    final name = String.fromCharCodes(bytes.sublist(2, 2 + nameLength));
    return Item(id, name);
  }

  Uint8List toBytes() =>
      Uint8List.fromList([id, name.length, ...name.codeUnits]);

  @override
  String toString() => 'Item(id: $id, name: $name)';
}

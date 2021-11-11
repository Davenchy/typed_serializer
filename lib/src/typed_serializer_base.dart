typedef SerializerFunction<T, R> = R Function(T object);
typedef DeserializerFunction<T, R> = T Function(R data);
typedef DetectorFunction<R> = bool Function(R data);

class TypedSerializerDefinition<T, R> {
  const TypedSerializerDefinition({
    required this.serialize,
    required this.deserialize,
    required this.detect,
  });

  /// convert object from type `T` to type `R`
  final SerializerFunction<T, R> serialize;

  /// convert object from type `R` to type `T`
  final DeserializerFunction<T, R> deserialize;

  /// check if object of type `R` can be converted to type `T`
  final DetectorFunction<R> detect;
}

mixin TypedSerializer<R> {
  final Map<Type, TypedSerializerDefinition> _definitions = {};

  /// set type `T` `definition`
  ///
  /// if type `T` already has a definition, it will be replaced
  void setObjectTypeDefinition<T>(TypedSerializerDefinition<T, R> definition) =>
      _definitions[T] = definition;

  /// create a definition for type `T`
  ///
  /// if type `T` already has a definition, it will be replaced
  ///
  /// `serialize` used to convert type `T` to type `R`
  ///
  /// `deserialize` used to convert type `R` to type `T`
  ///
  /// `detect` used to check if value to be deserialized can be converted to type `T`
  void createObjectDefinition<T>({
    required SerializerFunction<T, R> serialize,
    required DeserializerFunction<T, R> deserialize,
    required DetectorFunction<R> detect,
  }) {
    final definition = TypedSerializerDefinition<T, R>(
      serialize: serialize,
      deserialize: deserialize,
      detect: detect,
    );
    setObjectTypeDefinition(definition);
  }

  /// find object definition of type `T`
  ///
  /// if no definition found for type `T`, null will be returned
  TypedSerializerDefinition<T, R>? findObjectDefinition<T>() {
    return _definitions[T] as TypedSerializerDefinition<T, R>;
  }

  /// remove object definition of type `T` if exists
  void removeObjectDefinition<T>() => _definitions.remove(T);

  /// clear all defined object definitions to clean up memory
  void clearObjectDefinitions() => _definitions.clear();
}

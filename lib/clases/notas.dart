import 'package:uuid/uuid.dart';

class Nota {
  final String id;
  String titulo;
  String descripcion;
  double precio;
  DateTime creado;

  Nota({
    String? id,
    required this.titulo,
    required this.descripcion,
    required this.precio,
    DateTime? creado,
  })  : id = id ?? const Uuid().v4(),
        creado = creado ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'titulo': titulo,
        'descripcion': descripcion,
        'precio': precio,
        'creado': creado.toIso8601String(),
      };

  factory Nota.fromMap(String id, Map data) => Nota(
        id: id,
        titulo: data['titulo'] ?? '',
        descripcion: data['descripcion'] ?? '',
        precio: (data['precio'] ?? 0).toDouble(),
        creado: DateTime.parse(data['creado']),
      );
}

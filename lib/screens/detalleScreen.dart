import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../clases/notas.dart';
import '../services/firebase_service.dart';

class DetalleScreen extends StatefulWidget {
  final Nota? nota;
  const DetalleScreen({super.key, required this.nota});

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  final _titulo = TextEditingController();
  final _desc = TextEditingController();
  final _precio = TextEditingController();
  final _form = GlobalKey<FormState>();
  late bool _esNuevo;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _esNuevo = widget.nota == null;
    if (!_esNuevo) {
      _titulo.text = widget.nota!.titulo;
      _desc.text = widget.nota!.descripcion;
      _precio.text = widget.nota!.precio.toString();
    }
  }

  @override
  void dispose() {
    _titulo.dispose();
    _desc.dispose();
    _precio.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _guardando = true);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final servicio = FirebaseService();

    final nota = _esNuevo
        ? Nota(
            titulo: _titulo.text.trim(),
            descripcion: _desc.text.trim(),
            precio: double.parse(_precio.text),
          )
        : widget.nota!
          ..titulo = _titulo.text.trim()
          ..descripcion = _desc.text.trim()
          ..precio = double.parse(_precio.text);

    await servicio.guardar(uid, nota);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _borrar() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseService().borrar(uid, widget.nota!.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(_esNuevo ? 'Nueva nota' : 'Editar nota'),
          actions: [
            if (!_esNuevo)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.black,
                    title: const Text('Eliminar',
                        style: TextStyle(color: Colors.white)),
                    content: const Text(
                        '¿Seguro que deseas eliminar esta nota?',
                        style: TextStyle(color: Colors.white70)),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _borrar();
                          },
                          child: const Text('Eliminar',
                              style: TextStyle(color: Colors.redAccent))),
                    ],
                  ),
                ),
              )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  controller: _titulo,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (v) =>
                      v != null && v.isNotEmpty ? null : 'Requerido',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _desc,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _precio,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Precio'),
                  validator: (v) =>
                      double.tryParse(v ?? '') != null ? null : 'Número inválido',
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                    onPressed: _guardando ? null : _guardar,
                    child: _guardando
                        ? const CircularProgressIndicator()
                        : const Text('Guardar')),
              ],
            ),
          ),
        ),
      );
}

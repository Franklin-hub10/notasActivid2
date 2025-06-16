import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import 'listaScreen.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});
  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _mail = TextEditingController();
  final _pass = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _service = FirebaseService();
  bool _loading = false;
  String? _error;

  Future<void> _registrar() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final u = await _service.register(_mail.text.trim(), _pass.text.trim());
      if (u != null && mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ListaScreen()),
            (_) => false);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Registro')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _mail,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) =>
                        v != null && v.contains('@') ? null : 'Email inválido',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _pass,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (v) =>
                        v != null && v.length >= 6 ? null : 'Mínimo 6 caracteres',
                  ),
                  const SizedBox(height: 20),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: _loading ? null : _registrar,
                      child: _loading
                          ? const CircularProgressIndicator()
                          : const Text('Registrar')),
                ],
              ),
            ),
          ),
        ),
      );
}

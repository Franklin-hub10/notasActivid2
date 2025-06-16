import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import 'listaScreen.dart';
import 'registroScreen.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});
  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  final _mail = TextEditingController();
  final _pass = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _service = FirebaseService();
  bool _cargando = false;
  String? _error;

  Future<void> _ingresar() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final u = await _service.login(_mail.text.trim(), _pass.text.trim());
      if (u != null && mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ListaScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sticky_note_2,
                      size: 80, color: Colors.orange),
                  const SizedBox(height: 16),
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
                      onPressed: _cargando ? null : _ingresar,
                      child: _cargando
                          ? const CircularProgressIndicator()
                          : const Text('Ingresar')),
                  TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegistroScreen())),
                      child: const Text('Crear cuenta',
                          style: TextStyle(color: Colors.greenAccent))),
                ],
              ),
            ),
          ),
        ),
      );
}

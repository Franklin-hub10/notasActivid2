import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../clases/notas.dart';
import 'detalleScreen.dart';

class ListaScreen extends StatelessWidget {
  const ListaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final service = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis notas / gastos'),
        actions: [
          IconButton(
              onPressed: () => service.logout(),
              icon: const Icon(Icons.logout, color: Colors.redAccent))
        ],
      ),
      body: StreamBuilder<List<Nota>>(
        stream: service.notasStream(uid),
        builder: (_, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notas = snap.data!;
          if (notas.isEmpty) {
            return const Center(
                child: Text('Sin notas aún',
                    style: TextStyle(color: Colors.white70)));
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: notas.length,
            itemBuilder: (_, i) {
              final n = notas[i];
              return Card(
                color: Colors.grey[900],
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(n.titulo,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text('\$${n.precio.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.greenAccent)),
                  trailing: const Icon(Icons.chevron_right,
                      color: Colors.orangeAccent),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalleScreen(nota: n),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const DetalleScreen(nota: null))),
      ),
    );
  }
}

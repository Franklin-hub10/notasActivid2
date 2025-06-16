import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../clases/notas.dart';

class FirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref();

  // ---------- Auth ----------
  Future<User?> login(String email, String pass) async =>
      (await _auth.signInWithEmailAndPassword(email: email, password: pass))
          .user;

  Future<User?> register(String email, String pass) async =>
      (await _auth.createUserWithEmailAndPassword(
              email: email, password: pass))
          .user;

  Future<void> logout() => _auth.signOut();

  // ---------- Notas ----------
  DatabaseReference _refNotas(String uid) => _db.child('notas').child(uid);

  Stream<List<Nota>> notasStream(String uid) => _refNotas(uid).onValue.map(
        (e) => e.snapshot.children
            .map((snap) => Nota.fromMap(snap.key!, snap.value as Map))
            .toList(),
      );

  Future<void> guardar(String uid, Nota n) =>
      _refNotas(uid).child(n.id).set(n.toMap());

  Future<void> borrar(String uid, String id) =>
      _refNotas(uid).child(id).remove();
}

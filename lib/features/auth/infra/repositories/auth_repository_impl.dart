import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<UserEntity?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      final result = await getCurrentUserData();
      return result.fold(
        (failure) => null,
        (user) => user,
      );
    });
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUserData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return right(null);
      }

      final doc = await _firestore.collection('users').doc(currentUser.uid).get();
      
      if (!doc.exists) {
        return left(
          const AuthFailure(
            message: 'Perfil de usuário não encontrado na base de dados.',
            code: 'user-not-found-firestore',
          ),
        );
      }

      final user = UserModel.fromMap(doc.data(), currentUser.uid);
      return right(user);
    } on FirebaseException catch (e) {
      return left(ServerFailure(
        message: 'Erro ao conectar com o servidor: ${e.message}',
        code: e.code,
      ));
    } catch (e) {
      return left(AuthFailure(
        message: 'Ocorreu um erro inesperado ao carregar seus dados.',
        code: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      final uid = credential.user!.uid;
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        return left(
          const AuthFailure(
            message: 'Conta autenticada, mas o perfil não foi localizado.',
            code: 'profile-missing',
          ),
        );
      }

      final user = UserModel.fromMap(doc.data(), uid);
      return right(user);
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure(
        message: _handleFirebaseAuthException(e),
        code: e.code,
      ));
    } catch (e) {
      return left(AuthFailure(
        message: 'Erro inesperado durante o login. Tente novamente.',
        code: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      final uid = credential.user!.uid;
      final newUser = UserModel(
        id: uid,
        name: name.trim(),
        email: email.trim().toLowerCase(),
        role: 'aluno', 
        isActive: true,
        createdAt: DateTime.now(),
      );

      // Salva os dados cadastrais no Firestore
      await _firestore.collection('users').doc(uid).set(newUser.toMap());

      return right(newUser);
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure(
        message: _handleFirebaseAuthException(e),
        code: e.code,
      ));
    } catch (e) {
      return left(AuthFailure(
        message: 'Falha ao registrar usuário. Tente novamente.',
        code: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _auth.signOut();
      return right(unit);
    } catch (e) {
      return left(AuthFailure(
        message: 'Erro ao encerrar a sessão.',
        code: e.toString(),
      ));
    }
  }

  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        // Prevenção de enumeração: mesma resposta para email inexistente ou senha incorreta
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Este endereço de e-mail já está em uso.';
      case 'weak-password':
        return 'A senha deve conter pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'O formato do e-mail inserido é inválido.';
      case 'user-disabled':
        return 'Esta conta foi desativada temporariamente. Procure a administração.';
      case 'too-many-requests':
        return 'Muitas tentativas consecutivas. Aguarde alguns instantes.';
      default:
        return 'Falha na autenticação. Verifique os dados e tente novamente.';
    }
  }
}
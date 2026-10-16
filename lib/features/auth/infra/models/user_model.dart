import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.isActive,
    required super.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      return UserModel(
        id: documentId,
        name: 'Usuário',
        email: '',
        role: 'aluno',
        isActive: false,
        createdAt: DateTime.now(),
      );
    }

    return UserModel(
      id: documentId,
      name: (data['name'] as String?)?.trim() ?? 'Usuário',
      email: (data['email'] as String?)?.trim().toLowerCase() ?? '',
      // Segurança: se o campo não existir ou for qualquer coisa diferente de 'admin', o padrão SEMPRE é 'aluno'
      role: (data['role'] == 'admin') ? 'admin' : 'aluno',
      isActive: data['isActive'] as bool? ?? true,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] is DateTime
              ? data['createdAt'] as DateTime
              : DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
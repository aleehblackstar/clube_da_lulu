abstract class Failure {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}
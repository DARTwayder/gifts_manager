part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginLoginButtonClicked extends LoginEvent {
  const LoginLoginButtonClicked();

  @override
  List<Object?> get props => [];
}

class LoginRequestErrorShowed extends LoginEvent {
  const LoginRequestErrorShowed();

  @override
  List<Object?> get props => [];
}
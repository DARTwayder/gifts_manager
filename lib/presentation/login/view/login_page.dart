import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_manager/data/model/request_error.dart';
import 'package:gift_manager/presentation/home/view/home_page.dart';
import 'package:gift_manager/presentation/login/bloc/login_bloc.dart';
import 'package:gift_manager/presentation/login/model/email_error.dart';
import 'package:gift_manager/presentation/login/model/password_error.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: Center(
          child: _LoginPageWidget(),
        ),
      ),
    );
  }
}

class _LoginPageWidget extends StatefulWidget {
  const _LoginPageWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<_LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<_LoginPageWidget> {
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.authenticated) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => HomePage()),
              );
            }
          },
        ),
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.requestError != RequestError.noError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Произошлпа ошибка",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red[900],
              ));
              context.read<LoginBloc>().add(LoginRequestErrorShowed());
            }
          },
        ),
      ],
      child: Column(
        children: [
          SizedBox(height: 64),
          Center(
              child: Text(
            "Вход",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
          )),
          Spacer(flex: 88),
          _EmailTextField(
            emailFocusNode: _emailFocusNode,
            passwordFocusNode: _passwordFocusNode,
          ),
          SizedBox(height: 8),
          _PasswordTextField(passwordFocusNode: _passwordFocusNode),
          SizedBox(height: 40),
          _LoginButton(),
          SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Еще нет аккаунта?"),
              TextButton(
                  onPressed: () => debugPrint("Нажали на кнопку Создать"),
                  child: Text("Создать")),
            ],
          ),
          TextButton(
              onPressed: () => debugPrint("Нажали на кнопку Не помню пароль"),
              child: Text("Не помню пароль")),
          Spacer(flex: 284),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36),
      child: SizedBox(
        width: double.infinity,
        child: BlocSelector<LoginBloc, LoginState, bool>(
          selector: (state) => state.allFieldsValid,
          builder: (context, fieldsValid) {
            return ElevatedButton(
              onPressed: fieldsValid
                  ? () =>
                      context.read<LoginBloc>().add(LoginLoginButtonClicked())
                  : null,
              child: Text("Войти"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Color(0xB3366EC4);
                      }
                      return Color(0xFF2950AF);
                    },
                  ),
                  textStyle: MaterialStateProperty.all(
                      TextStyle(color: Colors.white, fontSize: 16))),
            );
          },
        ),
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({
    Key? key,
    required FocusNode emailFocusNode,
    required FocusNode passwordFocusNode,
  })  : _emailFocusNode = emailFocusNode,
        _passwordFocusNode = passwordFocusNode,
        super(key: key);

  final FocusNode _emailFocusNode;
  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36),
      child: BlocSelector<LoginBloc, LoginState, EmailError>(
        selector: (state) => state.emailError,
        builder: (context, emailError) {
          return TextField(
            focusNode: _emailFocusNode,
            onChanged: (text) =>
                context.read<LoginBloc>().add(LoginEmailChanged(text)),
            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
            decoration: InputDecoration(
                hintText: "Почта",
                errorText: emailError == EmailError.noError
                    ? null
                    : emailError.toString()),
          );
        },
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({
    Key? key,
    required FocusNode passwordFocusNode,
  })  : _passwordFocusNode = passwordFocusNode,
        super(key: key);

  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 36),
      child: BlocSelector<LoginBloc, LoginState, PasswordError>(
        selector: (state) => state.passwordError,
        builder: (context, passwordError) {
          return TextField(
            focusNode: _passwordFocusNode,
            onChanged: (text) =>
                context.read<LoginBloc>().add(LoginPasswordChanged(text)),
            onSubmitted: (_) =>
                context.read<LoginBloc>().add(LoginLoginButtonClicked()),
            decoration: InputDecoration(
                hintText: "Пароль",
                errorText: passwordError == PasswordError.noError
                    ? null
                    : passwordError.toString()),
          );
        },
      ),
    );
  }
}

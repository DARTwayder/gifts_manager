import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gift_manager/extensions/build_context.dart';
import 'package:gift_manager/extensions/theme_extesions.dart';
import 'package:gift_manager/presentation/home/view/home_page.dart';
import 'package:gift_manager/presentation/registration/bloc/registration_bloc.dart';
import 'package:gift_manager/resources/app_colors.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(),
      child: const Scaffold(
        body: _RegistrationPageWidget(),
      ),
    );
  }
}

class _RegistrationPageWidget extends StatefulWidget {
  const _RegistrationPageWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<_RegistrationPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<_RegistrationPageWidget> {
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _passwordConfirmationFocusNode;
  late final FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordConfirmationFocusNode = FocusNode();
    _nameFocusNode = FocusNode();

    SchedulerBinding.instance
        .addPostFrameCallback((_) => _addFocusPostHandlers());
  }

  void _addFocusPostHandlers() {
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<RegistrationBloc>().add(RegistrationEmailFocusLost());
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<RegistrationBloc>().add(RegistrationPasswordFocusLost());
      }
    });
    _passwordConfirmationFocusNode.addListener(() {
      if (!_passwordConfirmationFocusNode.hasFocus) {
        context
            .read<RegistrationBloc>()
            .add(RegistrationPasswordConfirmationFocusLost());
      }
    });
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        context.read<RegistrationBloc>().add(RegistrationNameFocusLost());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmationFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationCompleted) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Создать аккаунт', style: context.theme.h2),
                    ),
                    SizedBox(height: 24),
                    _EmailTextField(
                      emailFocusNode: _emailFocusNode,
                      passwordFocusNode: _passwordFocusNode,
                    ),
                    _PasswordTextField(
                      passwordFocusNode: _passwordFocusNode,
                      passwordConfirmationFocusNode:
                          _passwordConfirmationFocusNode,
                    ),
                    _PasswordConfirmationTextField(
                      passwordConfirmationFocusNode:
                          _passwordConfirmationFocusNode,
                      nameFocusNode: _nameFocusNode,
                    ),
                    _NameTextField(
                      nameFocusNode: _nameFocusNode,
                    ),
                    SizedBox(height: 16),
                    _AvatarWidget(),
                  ],
                ),
              ),
              _RegisterButton(),
            ],
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.emailError;
          return TextField(
            focusNode: _emailFocusNode,
            onChanged: (text) => context
                .read<RegistrationBloc>()
                .add(RegistrationEmailChanged(text)),
            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Почта',
              errorText: error?.toString(),
            ),
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
    required FocusNode passwordConfirmationFocusNode,
  })  : _passwordFocusNode = passwordFocusNode,
        _passwordConfirmationFocusNode = passwordConfirmationFocusNode,
        super(key: key);

  final FocusNode _passwordFocusNode;
  final FocusNode _passwordConfirmationFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.passwordError;
          return TextField(
            focusNode: _passwordFocusNode,
            onChanged: (text) => context
                .read<RegistrationBloc>()
                .add(RegistrationPasswordChanged(text)),
            onSubmitted: (_) => _passwordConfirmationFocusNode.requestFocus(),
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: 'Пароль',
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _PasswordConfirmationTextField extends StatelessWidget {
  const _PasswordConfirmationTextField({
    Key? key,
    required FocusNode passwordConfirmationFocusNode,
    required FocusNode nameFocusNode,
  })  : _passwordConfirmationFocusNode = passwordConfirmationFocusNode,
        _nameFocusNode = nameFocusNode,
        super(key: key);

  final FocusNode _passwordConfirmationFocusNode;
  final FocusNode _nameFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.passwordConfirmationError;
          return TextField(
            focusNode: _passwordConfirmationFocusNode,
            onChanged: (text) => context
                .read<RegistrationBloc>()
                .add(RegistrationPasswordConfirmationChanged(text)),
            onSubmitted: (_) => _nameFocusNode.requestFocus(),
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: 'Пароль второй раз',
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _NameTextField extends StatelessWidget {
  const _NameTextField({
    Key? key,
    required FocusNode nameFocusNode,
  })  : _nameFocusNode = nameFocusNode,
        super(key: key);

  final FocusNode _nameFocusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        buildWhen: (_, current) => current is RegistrationFieldsInfo,
        builder: (context, state) {
          final fieldsInfo = state as RegistrationFieldsInfo;
          final error = fieldsInfo.nameError;
          return TextField(
            focusNode: _nameFocusNode,
            onChanged: (text) => context
                .read<RegistrationBloc>()
                .add(RegistrationNameChanged(text)),
            onSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: 'Имя и фамилия',
              errorText: error?.toString(),
            ),
          );
        },
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.only(
        left: 8,
        top: 6,
        bottom: 6,
        right: 4,
      ),
      decoration: BoxDecoration(
          color: context.dynamicPlainColor(
            context: context,
            lightThemeColor: AppColors.lightLightBlue100,
            darkThemeColor: AppColors.darkWhite100,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          BlocBuilder<RegistrationBloc, RegistrationState>(
            buildWhen: (_, current) => current is RegistrationFieldsInfo,
            builder: (context, state) {
              final fieldsInfo = state as RegistrationFieldsInfo;
              return SvgPicture.network(
                fieldsInfo.avatarLink,
                height: 48,
                width: 48,
              );
            },
          ),
          const SizedBox(width: 8),
          Text('Ваш аватар', style: context.theme.h3),
          SizedBox(width: 8),
          Spacer(),
          TextButton(
              onPressed: () => context.read<RegistrationBloc>().add(
                    RegistrationChangeAvatar(),
                  ),
              child: Text('Изменить')),
        ],
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: BlocSelector<RegistrationBloc, RegistrationState, bool>(
          selector: (state) => state is RegistrationInProgress,
          builder: (context, fieldsValid) {
            return ElevatedButton(
              onPressed: fieldsValid
                  ? null
                  : () => context
                      .read<RegistrationBloc>()
                      .add(const RegistrationCreateAccount()),
              child: const Text("Создать"),
            );
          },
        ),
      ),
    );
  }
}

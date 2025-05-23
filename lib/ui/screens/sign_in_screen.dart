import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/ui/controllers/sign_in-controller.dart';
import 'package:task_manager_app/ui/screens/screens%20after%20signing%20in/tasks_screen.dart';
import 'package:task_manager_app/ui/screens/sign_up_screen.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/custom_text_form_field.dart';
import 'package:task_manager_app/ui/widgets/frosted_glass.dart';
import 'package:task_manager_app/ui/widgets/green_ball.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _isPasswordVisible = false;
  final SignInController signInController = Get.find<SignInController>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScreenBackground(
          child: Stack(
        children: [
          // the bg green ball
          const Center(
            child: GreenBall(),
          ),

          // the glass card
          FrostedGlass(
            width: 300,
            height: 550,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),

                  // Welcome msg
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Get Started With',
                      style: textTheme.displaySmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),

                  // email & pass form field
                  buildEmailPassColumn(),
                  const SizedBox(height: 15),

                  // the next button
                  buildNextButton(),
                  // const SizedBox(
                  //   height: 45,
                  // ),

                  // password recovery + Signing Up Buttons
                  buildPassRecoverSignUp()
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

// all builds down here 👇
  Widget buildEmailPassColumn() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailTEController,
            obscureText: false,
            hintText: 'Email',
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter a valid Email to proceed';
              }
              return null; // If the if condition is false (i.e., the input is not null and not empty), the validator function returns null. And returning null from a validator function means that the input is considered valid, and no error message should be displayed.
            },
          ),
          const SizedBox(height: 10),

          // pass form field
          CustomTextFormField(
            hintText: 'Password',
            controller: _passwordTEController,
            obscureText: _isPasswordVisible,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter your password';
              } else if (value!.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null; // If the if condition is false (i.e., the input is not null and not empty), the validator function returns null. And returning null from a validator function means that the input is considered valid, and no error message should be displayed.
            },
            suffixIcon: _togglePassword(),
          ),
        ],
      ),
    );
  }

  Padding buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SizedBox(
        width: double.infinity,
        child: GetBuilder<SignInController>(
          builder: (controller) {
            return Visibility(
              visible: controller.inProgress == false,
              // If _inProgress is false, it shows the button.
              replacement: const CenteredCircularProgressIndicator(),
              // If _inProgress is true, it shows a CenteredCircularProgressIndicator instead.
              child: ElevatedButton(
                onPressed: _onTapNextButton,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[500],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Icon(Icons.navigate_next_rounded),
              ),
            );
          }
        ),
      ),
    );
  }

  Column buildPassRecoverSignUp() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: (){},
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Don\'t have an account?'),
            TextButton(
              onPressed: _onTapSignUp,
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.green[500], fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // the sign in post request
  Future<void> _signIn() async {
    final bool result = await Get.find<SignInController>().signIn(
      _emailTEController.text.trim(),
      _passwordTEController.text,
    );

    if (result) {
      Get.offAllNamed(TasksScreen.name);
    } else {
      showSnackBarMessage(context, signInController.errorMessage!, true);
    }
  }

  // button functionalities
  void _onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _onTapNextButton() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _signIn();
  }

  Widget _togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
      icon: Icon(
        !_isPasswordVisible
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        color: Colors.grey,
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}

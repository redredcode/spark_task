import 'package:get/get.dart';
import 'package:task_manager_app/ui/controllers/profile_screen_controller.dart';
import 'package:task_manager_app/ui/controllers/sign_in-controller.dart';
import 'package:task_manager_app/ui/controllers/sign_up_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(ProfileScreenController());
    Get.put(SignUpController());
  }
}
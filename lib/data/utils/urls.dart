class Urls {
  static const String _baseUrl = 'http://143.110.241.146:8000';

  // Auth
  static const String registration = '$_baseUrl/user/register';
  static const String logIn = '$_baseUrl/user/login';
  static String activateUser = '$_baseUrl/user/activate-user';

  // Task
  static const String addNewTask = '$_baseUrl/task/create-task';
  static String deleteTask(String taskId) => '$_baseUrl/task/delete-task/$taskId';
  static const String getAllTask = '$_baseUrl/task/get-all-task';

  // User Profile
  static const String updateProfile = '$_baseUrl/ProfileUpdate';
  static const String readProfile = '$_baseUrl/user/my-profile';
}

import 'dart:convert';
import 'package:find_git_users/models/user_profile.dart';
import 'package:find_git_users/models/users.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  final String baseApi = "https://api.github.com/";

  //Search user by username
  Future<User?> searchUsers({searchQuery}) async {
    final String apiUrl = "${baseApi}search/users?q=$searchQuery";
    User? resultBean;
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      try {
        resultBean = User.fromJson(json.decode(response.body));
        return resultBean;
      } catch (e) {
        return resultBean;
      }
    } else {
      throw Exception('Failed to load posts');
    }
  }

  //Fetch user details to find repo count
  Future<String> fetchUserData({searchQuery}) async {
    final String apiUrl = "${baseApi}users/$searchQuery";
    UserProfile? resultBean;
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      try {
        resultBean = UserProfile.fromJson(json.decode(response.body));
        return resultBean.publicRepos.toString();
      } catch (e) {
        return '';
      }
    } else {
      return 'repo not found';
    }
  }
}
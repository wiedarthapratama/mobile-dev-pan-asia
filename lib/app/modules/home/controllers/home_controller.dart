import 'dart:convert';

import 'package:flutter_application_1/app/models/post.dart';
import 'package:flutter_application_1/app/models/user.dart';
import 'package:flutter_application_1/app/models/comment.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var users = <User>[].obs;
  var posts = <Post>[].obs;
  var isLoading = true.obs;
  var isLoadingComment = true.obs;

  @override
  void onInit() {
    // fetchUsers();
    fetchPosts();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void fetchUsers() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('https://dummyapi.io/data/v1/user'),
        headers: {
          'app-id':
              '661fbc776149567a45dec6d5', // Replace 'your-app-id' with your actual app ID
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        Iterable userJson = json['data'];
        List<User> userList =
            userJson.map((user) => User.fromJson(user)).toList();
        users.value = userList;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void fetchPosts() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('https://dummyapi.io/data/v1/post'),
        headers: {
          'app-id':
              '661fbc776149567a45dec6d5', // Replace 'your-app-id' with your actual app ID
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        Iterable userJson = json['data'];
        List<Post> postList =
            userJson.map((user) => Post.fromJson(user)).toList();
        posts.value = postList;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  handleExpand(Post post, bool isExpanded) {
    print('handleExpand');
    posts.where((p0) => p0.id == post.id).first.isExpanded = !isExpanded;
    // if (!post.isLoadComment) {
    fetchComments(post.id);
    // }
    update();
  }

  void fetchComments(String? postId) async {
    print("fetchComments");
    try {
      isLoadingComment(true);
      final response = await http.get(
        Uri.parse('https://dummyapi.io/data/v1/post/$postId/comment'),
        headers: {
          'app-id':
              '661fbc776149567a45dec6d5', // Replace 'your-app-id' with your actual app ID
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        Iterable userJson = json['data'];
        print(userJson);
        List<Comment> commentList =
            userJson.map((user) => Comment.fromJson(user)).toList();
        var post = posts.firstWhere((p) => p.id == postId);
        if (post != null) {
          post.isLoadComment = true;
          post.comments = commentList;
          update();
        } else {
          throw Exception('Post with postId $postId not found');
        }
        update();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingComment(false);
    }
  }
}

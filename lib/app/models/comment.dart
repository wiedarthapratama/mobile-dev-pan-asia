import 'package:flutter_application_1/app/models/user.dart';

class Comment {
  String? id;
  String? message;
  User? owner;
  String? post;
  String? publishDate;

  Comment({this.id, this.message, this.owner, this.post, this.publishDate});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    owner = json['owner'] != null ? User.fromJson(json['owner']) : null;
    post = json['post'];
    publishDate = json['publishDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    data['post'] = post;
    data['publishDate'] = publishDate;
    return data;
  }
}
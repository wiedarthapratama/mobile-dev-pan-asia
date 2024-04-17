import 'package:flutter_application_1/app/models/user.dart';
import 'package:flutter_application_1/app/models/comment.dart';

class Post {
  String? id;
  String? image;
  int? likes;
  List<String>? tags;
  String? text;
  String? publishDate;
  User? owner;
  late bool isExpanded;
  late bool isLoadComment;
  List<Comment>? comments;

  Post(
      {this.id,
      this.image,
      this.likes,
      this.tags,
      this.text,
      this.publishDate,
      this.owner,
      this.isExpanded = false,
      this.isLoadComment = false,
      this.comments});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    likes = json['likes'];
    tags = json['tags'].cast<String>();
    text = json['text'];
    publishDate = json['publishDate'];
    isExpanded = false;
    isLoadComment = false;
    owner = json['owner'] != null ? User.fromJson(json['owner']) : null;
    if (json['comments'] != null) {
      comments = <Comment>[];
      json['comments'].forEach((v) {
        comments!.add(Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['image'] = image;
    data['likes'] = likes;
    data['tags'] = tags;
    data['text'] = text;
    data['publishDate'] = publishDate;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    data['comments'] = comments;
    return data;
  }
}
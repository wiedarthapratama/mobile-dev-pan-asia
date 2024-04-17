import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/models/post.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView.builder(
                itemCount: controller.posts.length,
                itemBuilder: (context, index) {
                  var post = controller.posts[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: Get.width,
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(post.image ??
                                    ''), //harusnya pake ini: post.owner?.picture ?? '' karena error gambarnya pas di buka jadi bikin eror juga disini nya
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${post.owner?.firstName} ${post.owner?.lastName}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                      DateTime.parse(post.publishDate ?? '')))
                                ],
                              )
                            ],
                          ),
                        ),
                        Image.network(
                          post.image ?? '',
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Text('${post.likes} suka'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Text(post.text ?? ''),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Wrap(
                            spacing: 6.0,
                            runSpacing: 6.0,
                            children: post.tags!.map((tag) {
                              return Text(
                                '#$tag',
                                style: const TextStyle(color: Colors.blue),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GetBuilder<HomeController>(
                            builder: (controller) => ExpansionTile(
                                  title: const Text('Comments'),
                                  trailing: IconButton(
                                    icon: Icon(post.isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more),
                                    onPressed: () {
                                      controller.handleExpand(
                                          post, post.isExpanded);
                                    },
                                  ),
                                  children: post.isExpanded
                                      ? controller.isLoadingComment.value
                                          ? [const CircularProgressIndicator()]
                                          : _buildComments(post)
                                      : [],
                                ))
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildComments(Post post) {
    List<Widget> widgets = [];
    if (post.comments != null && post.comments!.isNotEmpty) {
      for (var i = 0; i < post.comments!.length; i++) {
        // Use the null-aware operator (?.) to access the nullable property safely
        widgets.add(ListTile(
            subtitle: Text(post.comments![i].message ?? ''),
            leading:
                CircleAvatar(backgroundImage: NetworkImage(post.image ?? '')),
            title: Text(
                "${post.comments![i].owner!.firstName} ${post.comments![i].owner!.lastName}")));
      }
    } else {
      widgets.add(const Text('Tidak ada Komentar'));
    }
    return widgets;
  }

  Future<void> _refreshPosts() async {
    // Perform whatever operations you need to refresh the posts
    controller.fetchPosts();
  }
}

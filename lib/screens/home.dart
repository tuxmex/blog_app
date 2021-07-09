import 'dart:convert';
import 'dart:ui';

import 'package:blog_app/models/blog_post.dart';
import 'package:blog_app/services/blog_post_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  BlogPostService _blogPostService = BlogPostService();

  void initState() {
    super.initState();
    _getAllBlogPosts();
  }

  Future<List<BlogPost>> _getAllBlogPosts() async {
    var result = await _blogPostService.getAllBlogPosts();
    List<BlogPost> _list = List.empty(growable: true);
    if (result != null) {
      var blogPosts = json.decode(result.body);
      blogPosts.forEach((blogPost) {
        print(blogPost);
        var model = BlogPost(blogPost['id'], blogPost['title'],
            blogPost['details'], blogPost['featured_image_url']);

        setState(() {
          _list.add(model);
        });
      });
    }
    print(result.body);
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post app'),
      ),
      body: FutureBuilder(
          future: _getAllBlogPosts(),
          builder:
              (BuildContext context, AsyncSnapshot<List<BlogPost>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Image.network(
                                  snapshot.data![index].featuredImageUrl),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                snapshot.data![index].title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Container(
                child: Text('Loading....'),
              );
            }
          }),
    );
  }
}

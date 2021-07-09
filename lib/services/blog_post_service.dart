import 'package:blog_app/repositories/repository.dart';

class BlogPostService {
  Repository _repository = Repository();

  getAllBlogPosts() async {
    return await _repository.httpGet('get-all-blog-posts');
  }
}

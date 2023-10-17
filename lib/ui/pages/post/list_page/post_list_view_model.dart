//1. 창고데이터
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListModel {
  List<Post> posts;

  PostListModel(this.posts);
}

//2. 창고
class PostListViewModel extends StateNotifier<PostListModel?> {
  PostListViewModel(super._state, this.ref);
  final mContext = navigatorKey.currentContext;
  final Ref ref;

  Future<void> notifyInit() async {
    //jwt 가져오기

    SessionUser sessionUser = ref.read(sessionProvider);

    ResponseDTO responseDTO =
        await PostRepository().fetchPostList(sessionUser.jwt!);
    state = PostListModel(responseDTO.data);
  }
}

//3. 창고관리자 (View가 빌드되기 직전에 생성)
final postListProvider =
    StateNotifierProvider.autoDispose<PostListViewModel, PostListModel?>((ref) {
  return PostListViewModel(null, ref)..notifyInit();
});

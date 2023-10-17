import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/model/user.dart';

//여기서는 통신이랑 파싱해서 데이터를 옮겨담기만할거임

class PostRepository {
  Future<ResponseDTO> fetchPostList(String jwt) async {
    try {
      final response = await dio.get("/post",
          options: Options(headers: {"Authorization": "${jwt}"}));

      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      responseDTO.data = User.fromJson(responseDTO.data);

      List<dynamic> mapList = responseDTO.data as List<dynamic>;
      List<Post> postList = mapList.map((e) => Post.fromJson(e)).toList();
      return responseDTO;
    } catch (e) {
      // 200이 아니면 catch로감.
      return ResponseDTO(-1, "중복되는 유저명입니다.", null);
    }
  }
}

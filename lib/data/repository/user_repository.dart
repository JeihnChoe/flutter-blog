import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/user.dart';

//여기서는 통신이랑 파싱해서 데이터를 옮겨담기만할거임

class UserRepository {
  Dio dio = Dio();

  Future<ResponseDTO> fetchJoin(JoinReqDTO requestDTO) async {
    try {
      //1. 통신으로 값을 받음
      final response = await dio.post("/join", data: requestDTO.toJson());
      //2. 받은 값의 형태에 맞도록 파싱해야함
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      //3. data 내에 User 객체가 맵의 형태로 있기 때문에,User를 다시 파싱해줘야함
      responseDTO.data = User.fromJson(responseDTO.data);
      return responseDTO;
    } catch (e) {
      // 200이 아니면 catch로감.
      return ResponseDTO(-1, "중복되는 유저명입니다.", null);
    }
  }
}

Future<ResponseDTO> fetchLogin(LoginReqDTO requestDTO) async {
  try {
    //1. 통신으로 값을 받음
    final response = await dio.post("/login", data: requestDTO.toJson());
    //2. 받은 값의 형태에 맞도록 파싱해야함
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
    //3. data 내에 User 객체가 맵의 형태로 있기 때문에,User를 다시 파싱해줘야함
    responseDTO.data = User.fromJson(responseDTO.data);
    //(추가) 4.로그인은 jwt를 받기 때문에, 이 받은걸 responseDTO에 옮겨줘야함.
    final jwt = response.headers["Authorization"]; // 정확하게는 Headers가
    if (jwt != null) {
      responseDTO.token =
          jwt[0] as String?; // headers 는 헤더가 여러개이므로, 토큰의 위치를 지정해줘야한다.
    }

    return responseDTO;
  } catch (e) {
    // 응답 스테이터스가 200이 아니면 catch로감.
    return ResponseDTO(-1, "중복되는 유저명입니다.", null);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user.dart';

// 1. 창고데이터
class SessionUser {
  //1. 화면 context에 접근하는 법
  final mContext = navigatorKey.currentContext;

  User? user;
  String? jwt; // jwt시간이 만료되면 토큰이 있어도 로그인이 안되어있을수있음
  bool? isLogin; // 유효한 토큰을 가지고 있는지를 확인해서 로그인유무를 판별한다

  SessionUser();

  Future<void> join(JoinReqDTO joinReqDTO) async {
    //1.통신코드
    ResponseDTO responseDTO = await UserRepository().fetchJoin(joinReqDTO);
    //2.비지니스로직
    if (responseDTO.code == 1) {
      Navigator.pushNamed(mContext!, Move.loginPage);
    } else {
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text("회원가입실패")));
    }
  }

  Future<void> login(loginReqDTO) async {
    //1.통신코드
    ResponseDTO responseDTO = await UserRepository().fetchJoin(loginReqDTO);
    //2.비지니스로직
    if (responseDTO.code == 1) {
      // 로그인이되면 뭘해야할까?
      //1. 세션값을 갱신해줘야함
      this.user = responseDTO.data as User;
      this.jwt = responseDTO.token;
      this.isLogin = true;

      //2. 디바이스에 JWT를 저장해줘야함.(자동로그인)
      await secureStorage.write(key: "jwt", value: responseDTO.token);
      //3. 화면 이동 시켜줘야함
      Navigator.pushNamed(mContext!, Move.postListPage);
    } else {
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text("님로그인안댐 망함 ㅃㅇ")));
    }
  }

  Future<void> logout() async {}

// 2. 창고
// 없어도댐

// 3. 창고관리자
}

final sessionProvider = Provider<SessionUser>((ref) {
  return SessionUser();
});

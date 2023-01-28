//
//  LoginViewController.swift
//  CommonPlant_iOS
//
//  Created by 다현 on 2023/01/16.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import Alamofire


class LoginViewController: UIViewController {

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //========== kakao login button==========
    @IBAction func kakaoLoginAction(_ sender: UIButton){
        print("kakao Login")
        //카카오 계정으로 로그인할 때
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                guard let accessToken = oauthToken?.accessToken else {
                    return
                }
                //accessToken
                print(accessToken)
                
                
                //accessToken으로 kakao 유저 데이터 가져오기
                let url = "https://kapi.kakao.com/v2/user/me"
                AF.request(url,
                                   method: .get,
                                   parameters: nil,
                                   encoding: URLEncoding.default,
                           headers: ["Content-Type":"application/x-www-form-urlencoded;charset=utf-8", "Authorization":"Bearer "+accessToken])
                            .validate(statusCode: 200..<300) //요청에 대한 유효성 검사 200<=300 상태만 허용
                            .responseJSON { (json) in
                                //여기서 가져온 데이터를 자유롭게 활용하세요.
                                print(json)
                                print(json.result.success.)
                        }
                
            }
        }

        
        
    }
    
    
    
    
    //========= nickname controller 전환 ============
    @IBAction func setnickname(_ sender: Any) {
        //로그인 화면의 storyboard ID를 참조하여 뷰 컨트롤러를 가져오기
        guard let toset = self.storyboard?.instantiateViewController(withIdentifier: "NicknameView") else {
            return
        }
        //화면 전환 애니메이션을 설정
        toset.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        //인자값으로 다음 뷰 컨트롤러를 넣고 present 메소드를 호출
        self.present(toset, animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

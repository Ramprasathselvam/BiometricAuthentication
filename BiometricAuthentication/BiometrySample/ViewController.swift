//
//  ViewController.swift
//  BiometrySample
//
//  Created by Konda Reddy on 03/03/20.
//  Copyright © 2020 vss. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet var identyBtn:UIButton!
    
    let context = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.beingIdentity()
    }
    
    @IBAction func identyBtnTabbed(){
        self.beingIdentity()
    }
    
    func beingIdentity(){
        
        var error:NSError?
        
        guard self.context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) else{
            return print(error!)
        }
        if self.context.biometryType == .faceID {
           //Face id
            print("FaceId")
            self.identyBtn.setImage(UIImage(named: "ic_face"), for: .normal)
        }else if self.context.biometryType == .touchID{
            //Touch Id
            print("TouchId")
            self.identyBtn.setImage(UIImage(named: "ic_fingerprint"), for: .normal)
        }else {
            //none
            print("None")
        }
        let reason = "Identity yourselt to countinue"
        
        self.context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reason) { (isSuccess, error) in
            if isSuccess {
                //Success
                print("Success")
            }else{
                //Error
                self.showLAError(laError: error!)
            }
        }
    }
    
    // function to detect an error type
    func showLAError(laError: Error) -> Void {
        var message = ""
        switch laError {
        case LAError.appCancel:
            message = "Authentication was cancelled by application"
        case LAError.authenticationFailed:
            message = "The user failed to provide valid credentials"
        case LAError.invalidContext:
            message = "The context is invalid"
        case LAError.passcodeNotSet:
            message = "Passcode is not set on the device"
        case LAError.systemCancel:
            message = "Authentication was cancelled by the system"
        case LAError.biometryLockout:
            message = "Too many failed attempts."
            case LAError.biometryNotAvailable:
            message = "TouchID is not available on the device"
        case LAError.userCancel:
            message = "The user did cancel"
        case LAError.userFallback:
            message = "The user chose to use the fallback"
        default:
            if #available(iOS 11.0, *) {
                switch laError {
                case LAError.biometryNotAvailable:
                    message = "Biometry is not available"
                case LAError.biometryNotEnrolled:
                    message = "Authentication could not start, because biometry has no enrolled identities"
                case LAError.biometryLockout:
                    message = "Biometry is locked. Use passcode."
                default:
                    message = "Did not find error code on LAError object"
                }
            }else{
                message = "Did not find error code on LAError object"
            }
        }
        //return message
        print("LAError message - \(message)")
    }
}


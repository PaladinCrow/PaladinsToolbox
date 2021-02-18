//
//  AlertCenter.swift
//  PaladinsToolbox
//
//  Created by John Stanford on 2/17/21.
//

import UIKit

public class AlertCenter {
    private init() {}
    public static var shared = AlertCenter()
    func presentAlert(with message: String, in view: UIViewController) {
        let alertView = UIAlertController(title: "Error",
                                          message: message,
                                          preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: .default)
        alertView.addAction(okAction)
        view.present(alertView, animated: true)
    }
}

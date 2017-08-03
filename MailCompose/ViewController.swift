//
//  ViewController.swift
//  MailCompose
//
//  Created by Xcode on 2017/5/5.
//  Copyright © 2017年 wtfcompany. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 110, height: 40))
        button.center = self.view.center
        button.setTitle("電子郵件", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.layer.cornerRadius = 8.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.addTarget(self, action: #selector(self.onButtonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func onButtonAction() {
        if MFMailComposeViewController.canSendMail() {
            //設置收件者、標題、內文
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["sale1@xxx.net.tw", "sale2@xxx.net.tw"])
            mailComposeVC.setCcRecipients(["manager@xxx.net.tw"])
            mailComposeVC.setBccRecipients(["tsaenogard@gmail.com"])
            mailComposeVC.setSubject("採購報價")
            mailComposeVC.setMessageBody("Hi", isHTML: false)
            //設置附件 - image
            if let image = UIImage(named: "ocean.jpeg"), let data = UIImagePNGRepresentation(image) {
                mailComposeVC.addAttachmentData(data, mimeType: "image/jepg", fileName: "XXX.jpg")
            }
            //設置附件 - database
            if let path = Bundle.main.path(forResource: "myDB", ofType: "sqlite") {
                let url = URL(fileURLWithPath: path)
                do {
                    let data = try Data(contentsOf: url)
                    mailComposeVC.addAttachmentData(data, mimeType: "text/sqlite", fileName: "xxxx.sqlite")
                } catch {
                    print("無法取得sqlite檔案")
                }
            }
            
            //設置附件 - .csv
            var data = Data()
            
            data.appendString("學號\t姓名\t成績\n")
            data.appendString("1\t小明\t99\n")
            data.appendString("2\t小王\t100\n")
            data.appendString("3\t小強\t92\n")
            data.appendString("4\t小花\t90\n")
            mailComposeVC.addAttachmentData(data, mimeType: "text/csv", fileName: "score.csv")

            self.present(mailComposeVC, animated: true, completion: nil)
        }else {
            print("此設備無法發送郵件")
        }
    }
}

extension Data {

    mutating func appendString(_ str: String) {
        self.append(str.data(using: .unicode)!)
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {

        case .sent:
            print("郵件發送成功")
        default:
            print("郵件尚未發送")
        }
        self.dismiss(animated: true, completion: nil)
    }
}


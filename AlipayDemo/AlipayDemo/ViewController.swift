//
//  ViewController.swift
//  AlipayDemo
//
//  Created by 张青明 on 15/9/8.
//  Copyright (c) 2015年 极客栈. All rights reserved.
//

import UIKit

/// 合作者身份(PID)2088开头的16位数字。
let AlipayPartner = ""
/// 支付宝账号
let AlipaySeller  = ""
/// RSA私钥转化的pkcs8格式
let AlipayPrivateKey = ""

/// 服务器异步通知页面
let AlipayNotifyURL = "http://121.40.49.111:80/userAdmin/alipaySuccess"

/// 应用注册scheme,在AlixPayDemo-Info.plist定义URL types
let AliURLScheme = "alisdkdemo"
/// 签名方式,目前只有"RSA"
let AliSignType = "RSA"

class ViewController: UIViewController {

    @IBOutlet weak var ttfAmount: UITextField!
//    @IBOutlet weak var toPayOnClick: UIButton!
    
    @IBAction func toPayOnClick(sender: AnyObject) {


        
        //partner和seller获取失败,提示
        if count(AlipayPartner) == 0 || count(AlipaySeller) == 0 || count(AlipayPrivateKey) == 0
        {
            var alert = UIAlertView(title: "提示", message: "缺少partner或者seller或者私钥。", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return;
        }
        
        /*
        *生成订单信息及签名
        */
        //将商品信息赋予AlixPayOrder的成员变量

        var amount:CGFloat = 0.0

        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormatter.minimumFractionDigits = 3
        numberFormatter.maximumFractionDigits = 3
        if let n = numberFormatter.numberFromString(ttfAmount.text)
        {
            amount = CGFloat(n)
            print("amount:\(amount)\n")
        }
        
        
        var order          = Order()
        order.partner      = AlipayPartner
        order.seller       = AlipaySeller
        order.tradeNO      = Order.generateTradeNO() //订单ID（由商家自行制定）
        order.productName  = "商品标题" //商品标题
        order.productDescription = "商品描述" //商品描述

        if amount <= 0.0
        {
            return
        }
        order.amount       = String(format: "%.2f", amount)
        if order.amount == "0.00"
        {
            return
        }
        
        order.notifyURL    = AlipaySeller  //回调URL
        order.service      = "mobile.securitypay.pay"
        order.paymentType  = "1"
        order.inputCharset = "utf-8"
        order.itBPay       = "30m"
        order.showUrl      = "m.alipay.com"
        
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        var appScheme      = "alisdkdemo"
        
        //将商品信息拼接成字符串
        var orderSpec      = order.description
        print("orderSpec:\(orderSpec)\n")
        
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        var signer = CreateRSADataSigner(AlipayPrivateKey)
        var signedString = signer.signString(orderSpec)//[signer signString:orderSpec];
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        var orderString = ""
        if (signedString != nil) {
            
            orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"RSA\""
            

            
            AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme, callback: { (resultDic) -> Void in
                var memo = resultDic["memo"] as! String
                var result = resultDic["result"] as! String
                var resultStatus = resultDic["resultStatus"] as! String
                print("memo = %@, result = %@, resultStatus:%@")
            })
            
        }
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
}


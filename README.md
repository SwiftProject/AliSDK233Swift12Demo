###iOS支付宝SDK集成开发(Swift1.2)
---

#### 运行环境
* 系统:OS X Yosemite 10.10.3
* IDE  :Xcode 6.4 
* 语言:Swift 1.2
####添加支付宝SDK2.2.3
* 新建一个文件夹,命名为`AliSDK2_2_3`
* `AliSDK2_2_3`包含: `Util`、`openssl`、`libssl.a`、`libcrypto.a`、`AlipaySDK.bundle`、`AlipaySDK.framework`、`APAuthV2Info.h`、`APAuthV2Info.m`、`Order.h`、`Order.m`。**注:以上文件夹、文件、框架来自`支付宝Demo`。**[集成开发包下载链接](https://b.alipay.com/order/productDetail.htm?productId=2014110308141993&tabId=4#ps-tabinfo-hash)
* 把`AliSDK2_2_3`添加到工程
* 添加`SystemConfiguration.framework`(**此必需添加的框架**)

---

#### 编译一下，有错误。解决如下：
- [x] `Util`文件夹下`base64.h`添加`#import <Foundation/Foundation.h>`
```objective-c
#import <Foundation/Foundation.h>
@interface Base64 : NSObject

+ (NSData *)decodeString:(NSString *)string;

@end
```
- [X] `Util`文件夹下`openssl_wrapper.h`添加`#import <Foundation/Foundation.h>`
- [X] Error : Lexical or Preprocessor Issue 'openssl/asn1.h' file not found
 Targets-->工程-->Build Settings-->`Search Paths-->Header Search Paths(可以直接搜索)`-->添加`$(PROJECT_DIR)/AlipayDemo/AliSDK2_2_3`或者`$(SRCROOT)/AliSDKDemo/AliSDK2_3_3`**注：最安全的写法是，查看Framework Search Paths里面对应的路径**

---

####支付宝回调应用设置
* 添加URL types
   点击项目名称-->"Info"-->URL Types-->点击'+'-->URL Schemes填写与订单中的一样,Role选择Editor。


####**`高能提醒`**:如果App类型选择`iPad`或者`Universal`,那么iPad支付时，会在app内打开内嵌的支付宝页面，即不会跳转到支付宝移动端（即使你已经安装了）
####`温馨提示`
遇到问题，b.alipay.com/support/helperApply.htm?action=supportHome点击页面右边“有问题点我”

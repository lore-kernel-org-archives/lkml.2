Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab2LNKDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 05:03:08 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:44558 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2LNKDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 05:03:04 -0500
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "greg@kroah.com" <greg@kroah.com>, "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        Huqiao <huqiao36@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggMS8xXWxpbnV4LXVzYjogb3B0aW1pemUgdG8gbWF0?=
 =?utf-8?B?Y2ggdGhlIEh1YXdlaSBVU0Igc3RvcmFnZSBkZXZpY2VzIGFuZCBzdXBwb3J0?=
 =?utf-8?Q?_new_switch_command?=
Thread-Topic: [PATCH 1/1]linux-usb: optimize to match the Huawei USB storage
 devices and support new switch command
Thread-Index: AQHN2FaweIm5oeNb4kuKUXcBKWvQ25gXlv4g///t3YCAAI4BcA==
Date: Fri, 14 Dec 2012 10:02:36 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F326FC01A1@szxeml546-mbs.china.huawei.com>
References: <fe8c905bb12.b12fe8c905b@huawei.com>
	<20121212105151.09635a76@pyramind.ukuu.org.uk>
	<910F9D9E13B84F4C8FA771DC9BDE99F326FBFB54@szxeml546-mbs.china.huawei.com>
 <20121214093141.7e4eba61@pyramind.ukuu.org.uk>
In-Reply-To: <20121214093141.7e4eba61@pyramind.ukuu.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.34.182]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBEA3Dkn032318



> -----é‚®ä»¶åŸä»¶-----
> å‘ä»¶äºº: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
> å‘é€æ—¶é—´: 2012å¹´12æœˆ14æ—¥ 17:32
> æ”¶ä»¶äºº: Fangxiaozhi (Franko)
> æŠ„é€: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Xueguiying
> (Zihan); Linlei (Lei Lin); greg@kroah.com; Yili (Neil); Wangyuhua (Roger,
> Credit); Huqiao
> ä¸»é¢˜: Re: [PATCH 1/1]linux-usb: optimize to match the Huawei USB storage
> devices and support new switch command
> 
> On Fri, 14 Dec 2012 03:01:24 +0000
> "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com> wrote:
> 
> > Dear Alan:
> >
> > 	This prevents people getting access to the storage device if they want.
> > 	----In our device, after its switching, it will keep the cdrom port
> together with other ports (such as modem port). So you can access the
> storage device too, after our switch.
> 
> Ok so the behaviour is
> 
> 	plug in device
> 	"I am a CD-ROM"
> 	command sent
> 	"I am a CD-ROM, I am a modem, I am other things"
> 
> with the newer devices ?
> 
> Alan
------------Yes, you are right.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

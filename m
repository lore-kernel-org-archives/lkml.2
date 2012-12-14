Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab2LNK2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 05:28:47 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:16004 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2LNK2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 05:28:45 -0500
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "greg@kroah.com" <greg@kroah.com>, "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        Huqiao <huqiao36@huawei.com>
Subject: RE: [PATCH 1/1]linux-usb: optimize to match the Huawei USB storage
 devices and support new switch command
Thread-Topic: [PATCH 1/1]linux-usb: optimize to match the Huawei USB storage
 devices and support new switch command
Thread-Index: AQHN2FaweIm5oeNb4kuKUXcBKWvQ25gXlv4g///t3YCAAACNgIAAkuEw
Date: Fri, 14 Dec 2012 10:28:31 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F326FC0242@szxeml546-mbs.china.huawei.com>
References: <fe8c905bb12.b12fe8c905b@huawei.com>
 <910F9D9E13B84F4C8FA771DC9BDE99F326FBFB54@szxeml546-mbs.china.huawei.com>
 <20121214093141.7e4eba61@pyramind.ukuu.org.uk>
 <1758237.OLMhWhauCd@linux-lqwf.site>
In-Reply-To: <1758237.OLMhWhauCd@linux-lqwf.site>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBEASqLt032420

Dear Oliver:

> -----Original Message-----
> From: Oliver Neukum [mailto:oneukum@suse.de]
> Sent: Friday, December 14, 2012 5:34 PM
> To: Alan Cox
> Cc: Fangxiaozhi (Franko); linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; Xueguiying (Zihan); Linlei (Lei Lin);
> greg@kroah.com; Yili (Neil); Wangyuhua (Roger, Credit); Huqiao
> Subject: Re: [PATCH 1/1]linux-usb: optimize to match the Huawei USB
> storage devices and support new switch command
> 
> On Friday 14 December 2012 09:31:41 Alan Cox wrote:
> > On Fri, 14 Dec 2012 03:01:24 +0000
> > "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com> wrote:
> >
> > > Dear Alan:
> > >
> > > 	This prevents people getting access to the storage device if they want.
> > > 	----In our device, after its switching, it will keep the cdrom port
> together with other ports (such as modem port). So you can access the
> storage device too, after our switch.
> >
> > Ok so the behaviour is
> >
> > 	plug in device
> > 	"I am a CD-ROM"
> > 	command sent
> > 	"I am a CD-ROM, I am a modem, I am other things"
> >
> > with the newer devices ?
> 
> For such devices we should put the switching code into generic code, not a
> device driver so that we have a chance to do reset_resume() on those
> devices.
--------------Because in many embedded linux system, they don't include such switch tools themselves. 
			So I think it is better to put the switching code in device driver.
--------------By the way, because our device will response the switching command for once, 
			so I think you can do reset_resume() as you want.

> 	Regards
> 		Oliver

Best Regards,
Franko Fang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

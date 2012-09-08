Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2IHD0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 23:26:20 -0400
Received: from mga14.intel.com ([143.182.124.37]:28252 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab2IHD0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 23:26:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,390,1344236400"; 
   d="scan'208";a="190287464"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RESEND] USB/host: Cleanup unneccessary irq disable code
Thread-Topic: [PATCH RESEND] USB/host: Cleanup unneccessary irq disable code
Thread-Index: AQHNjI8l1bhi80ax80i2oD2lS38uQZd/yaKQ
Date: Sat, 8 Sep 2012 03:26:11 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A17B12B@SHSMSX101.ccr.corp.intel.com>
References: <1347009599.1119.9.camel@cliu38-desktop-build>
In-Reply-To: <1347009599.1119.9.camel@cliu38-desktop-build>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q883RHTH010584


> -----Original Message-----
> From: Liu, Chuansheng
> Sent: Friday, September 07, 2012 5:20 PM
> To: gregkh@linuxfoundation.org
> Cc: linux-kernel@vger.kernel.org
> Subject: [PATCH RESEND] USB/host: Cleanup unneccessary irq disable code
> 
> Because the IRQF_DISABLED as the flag is now a NOOP and has been
> deprecated and in hardirq context the interrupt is disabled.
> 
> so in usb/host code:
> Removing the usage of flag IRQF_DISABLED;
> Removing the calling local_irq save/restore actions in irq
> handler usb_hcd_irq();
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Hi greg,
This new patch is still not OK in a right format to apply? Please let me know, thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

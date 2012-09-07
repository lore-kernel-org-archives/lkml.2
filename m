Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab2IGJQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:16:13 -0400
Received: from sjdcsican04.udc.trendmicro.com ([66.180.85.17]:41143 "EHLO
	sjdciscan04.udc.trendmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757914Ab2IGJQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:16:11 -0400
X-Greylist: delayed 1731 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Sep 2012 05:16:11 EDT
From: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>
To: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: RE: [PATCH] block: move the dereference below the NULL test
Thread-Topic: [PATCH] block: move the dereference below the NULL test
Thread-Index: AQHNjMb69Ey80wCtlUGV+D2mgfcNzJd+kRsQ
Date: Fri, 7 Sep 2012 08:47:16 +0000
Message-ID: <A360F954C61C69449463B060666371121CDCB094@CDCEXMBX01.tw.trendnet.org>
References: <CAPgLHd_T_ApNEibN_VYHzs9fA9YahFwjkfj2T4+UYtPdhzC3zA@mail.gmail.com>
In-Reply-To: <CAPgLHd_T_ApNEibN_VYHzs9fA9YahFwjkfj2T4+UYtPdhzC3zA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.44.131]
Content-Type: text/plain;
	charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q879GQDx006398

Sorry, I see the patch fix this issue has already exists in the maillist,
please ignore it, thanks.

-----Original Message-----
From: Wei Yongjun [mailto:weiyj.lk@gmail.com] 
Sent: 2012Äê9ÔÂ7ÈÕ 15:04
To: grant.likely@secretlab.ca; rob.herring@calxeda.com
Cc: Yongjun Wei (RD-CN); linux-kernel@vger.kernel.org; devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] block: move the dereference below the NULL test

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)



TREND MICRO EMAIL NOTICE
The information contained in this email and any attachments is confidential and may be subject to copyright or other intellectual property protection. If you are not the intended recipient, you are not authorized to use or disclose this information, and we request that you notify us by reply mail or telephone and delete the original message from your mail system.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

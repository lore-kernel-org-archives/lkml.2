Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030382Ab2HQBtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 21:49:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19278 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab2HQBtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 21:49:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6806"; a="226254974"
X-IronPort-AV: E=Sophos;i="4.77,782,1336374000"; 
   d="scan'208";a="370139420"
From: "Ren, Cloud" <cjren@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: RE: [PATCH] net: add new QCA alx ethernet driver
Thread-Topic: [PATCH] net: add new QCA alx ethernet driver
Thread-Index: AQHNe7FV6PRqpmernk28qOEelr0rNJddPQ+Q
Date: Fri, 17 Aug 2012 01:49:05 +0000
Message-ID: <6349D7A510622448B1BA0967850A84380137365C@NASANEXD02D.na.qualcomm.com>
References: <1345053189-10326-1-git-send-email-cjren@qca.qualcomm.com>
 <1345122983.26882.9.camel@joe2Laptop>
In-Reply-To: <1345122983.26882.9.camel@joe2Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.235.13.225]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7H1nGL2031490

From: Joe Perches [mailto:joe@perches.com]
Sent: Thursday, August 16, 2012 9:16 PM
>Hi Cloud.  Please convert this to
>
>		netdev_printk(level, hw->adpt->netdev, "%pV", &vaf);
>
>I will submit a patch soon to make the __netdev_printk variant static.

Ok, thanks.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

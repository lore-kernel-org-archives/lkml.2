Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab2HXB4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:56:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32793 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab2HXB4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:56:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6813"; a="228876916"
X-IronPort-AV: E=Sophos;i="4.80,301,1344236400"; 
   d="scan'208";a="288180345"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Miller <davem@davemloft.net>, "Ren, Cloud" <cjren@qca.qualcomm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: RE: [PATCH v2] net: add new QCA alx ethernet driver
Thread-Topic: [PATCH v2] net: add new QCA alx ethernet driver
Thread-Index: AQHNfq/QcigpFEkeAUuvSgE/Sf2tgZdnYDEA//+NnwCAAXEzAP//2Otg
Date: Fri, 24 Aug 2012 01:55:59 +0000
Message-ID: <157393863283F442885425D2C45428562A4F54E3@nasanexd02f.na.qualcomm.com>
References: <1345480949-14800-1-git-send-email-cjren@qca.qualcomm.com>
	 <20120822.225700.714020017287504609.davem@davemloft.net>
	 <157393863283F442885425D2C45428562A4F5169@nasanexd02f.na.qualcomm.com>
 <1345756142.2579.16.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1345756142.2579.16.camel@bwh-desktop.uk.solarflarecom.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.48.1]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7O1uUSm000916

Thanks for all your feedback. I have another question need your help.

This NIC has special function that could receive/transmit simple packet when it's in sleep (D3) state.
It will help someone wakeup his/her machine even it's behind a router.
This function is disabled by default. To enable it, the NIC should be configured by app.
My question is which interface can I select to configure(write to) the NIC register ?

Thanks
Xiong

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

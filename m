Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab2HIEoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 00:44:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30237 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab2HIEoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 00:44:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6797"; a="220547572"
X-IronPort-AV: E=Sophos;i="4.77,737,1336374000"; 
   d="scan'208";a="160363930"
From: "Ren, Cloud" <cjren@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "Hao-Ran Liu(Joseph Liu)" <hao-ran.liu@canonical.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: RE: [PATCH] net: add new QCA alx ethernet driver
Thread-Topic: [PATCH] net: add new QCA alx ethernet driver
Thread-Index: AQHNddTR6PRqpmernk28qOEelr0rNJdQvhvwgACVLgD//5K5UA==
Date: Thu, 9 Aug 2012 04:44:08 +0000
Message-ID: <6349D7A510622448B1BA0967850A843801369364@NASANEXD02D.na.qualcomm.com>
References: <1344507270-2907-1-git-send-email-cjren@qca.qualcomm.com>
	 <6349D7A510622448B1BA0967850A8438013692CA@NASANEXD02D.na.qualcomm.com>
 <1344485382.2024.9.camel@joe2Laptop>
In-Reply-To: <1344485382.2024.9.camel@joe2Laptop>
Accept-Language: en-US
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q794iL6S025029

Hi Jeo
I only want to do some additional explanations to david. It makes nothing with original patch.
Thanks
cloud

-----Original Message-----
From: Joe Perches [mailto:joe@perches.com] 
Sent: 2012å¹´8æœˆ9æ—¥ 12:10
To: Ren, Cloud
Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; qca-linux-team; nic-devel; Huang, Xiong; Hao-Ran Liu(Joseph Liu); Rodriguez, Luis
Subject: RE: [PATCH] net: add new QCA alx ethernet driver

On Thu, 2012-08-09 at 02:27 +0000, Ren, Cloud wrote:
> Hi David,
[]
> The alx driver only supports two new nics(l1f/l2f) now.  It doesn't supersede atl1c driver.
> Atl1c driver still supports old nics.
[]
> -----Original Message-----
> From: Ren, Cloud
> Sent: 2012å¹´8æœˆ9æ—¥ 18:15
[]
> This driver support two new ethernet chipsets:

[+400kb of entire original patch]

Did you really have to quote 400kb of original patch to make that prefixing statement to David?

[]


> Signed-off-by: Joe Perches <joe@perches.com>
 
I would prefer my name not be listed as a Signed-off-by.

I don't have a card, I never tested it, etc.  What I did do is a light review and made a couple of trivial patch suggestions about how you might make logging code a bit smaller.

Thanks and cheers, Joe

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

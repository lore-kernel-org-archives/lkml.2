Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab2HXCji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 22:39:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43999 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977Ab2HXCjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 22:39:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6813"; a="226586837"
X-IronPort-AV: E=Sophos;i="4.80,301,1344236400"; 
   d="scan'208";a="374748747"
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
Thread-Index: AQHNfq/QcigpFEkeAUuvSgE/Sf2tgZdnYDEA//+NnwCAAXEzAP//2OtggAB7GQD//5FtAA==
Date: Fri, 24 Aug 2012 02:39:03 +0000
Message-ID: <157393863283F442885425D2C45428562A4F5546@nasanexd02f.na.qualcomm.com>
References: <1345480949-14800-1-git-send-email-cjren@qca.qualcomm.com>
	 <20120822.225700.714020017287504609.davem@davemloft.net>
	 <157393863283F442885425D2C45428562A4F5169@nasanexd02f.na.qualcomm.com>
	 <1345756142.2579.16.camel@bwh-desktop.uk.solarflarecom.com>
	 <157393863283F442885425D2C45428562A4F54E3@nasanexd02f.na.qualcomm.com>
 <1345774184.2579.51.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1345774184.2579.51.camel@bwh-desktop.uk.solarflarecom.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7O2dsHw001010

> 
> If you want to implement a more sophisticated packet matching mode that
> requires more details than struct ethtool_wolinfo, then you may need to
> define new operations.
> 
It's great ! 
Is it ok for ethtool to define a new operation with a sophisticated structure (like ethtool_eee) ?

Thanks
Xiong
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2HMBT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 21:19:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20925 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab2HMBT1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 21:19:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6801"; a="224540189"
X-IronPort-AV: E=Sophos;i="4.77,757,1336374000"; 
   d="scan'208";a="305561401"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: Stephen Hemminger <shemminger@vyatta.com>,
        "Ren, Cloud" <cjren@qca.qualcomm.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Hao-Ran Liu(Joseph Liu)" <hao-ran.liu@canonical.com>,
        Joe Perches <joe@perches.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: RE: [PATCH] net: add new QCA alx ethernet driver
Thread-Topic: [PATCH] net: add new QCA alx ethernet driver
Thread-Index: AQHNddTRDXcTbtvZbUiDfP8UijeOlpdVj6IAgAFnQbA=
Date: Mon, 13 Aug 2012 01:19:24 +0000
Message-ID: <157393863283F442885425D2C4542856282E0637@nasanexd02f.na.qualcomm.com>
References: <1344507270-2907-1-git-send-email-cjren@qca.qualcomm.com>
 <20120811135044.529a7081@nehalam.linuxnetplumber.net>
In-Reply-To: <20120811135044.529a7081@nehalam.linuxnetplumber.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.235.14.28]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Stephen Hemminger [mailto:shemminger@vyatta.com]
> Sent: Sunday, August 12, 2012 4:51
> To: Ren, Cloud
> > +	strcpy(netdev->name, "eth%d");
> > +	retval = register_netdev(netdev);
> 
> The strcpy is unnecessary, alloc_etherdev already sets that.

Thanks, Hemminger, we will remove this line in the next post.

-Xiong

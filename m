Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab1JTJXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:23:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27976 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1JTJXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:23:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6504"; a="129338350"
X-IronPort-AV: E=Sophos;i="4.69,375,1315206000"; 
   d="scan'208";a="91193028"
From: "Ren, Cloud" <cjren@qca.qualcomm.com>
To: David Miller <davem@davemloft.net>
CC: "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
Thread-Topic: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
Thread-Index: AQHMjvQO9EGPKqVzTkOxaT8937sMf5WFYLyA//+Sl8A=
Date: Thu, 20 Oct 2011 09:23:07 +0000
Message-ID: <6349D7A510622448B1BA0967850A8438011CC21D@nasanexd02d.na.qualcomm.com>
References: <1319093184-19696-1-git-send-email-cloud.ren@Atheros.com>
 <20111020.044541.970282389722164761.davem@davemloft.net>
In-Reply-To: <20111020.044541.970282389722164761.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.45.230.6]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From: <cloud.ren@Atheros.com>
>Date: Thu, 20 Oct 2011 14:46:24 +0800
>
>> +#define __far
>
>So much unused crap left in these header files, get rid of this stuff.
>
>+#define ALX_HW_WARN(_fmt, _args...) \
>+		ALX_HW_PRINTA(WARNING, _fmt, ## _args)
>+
>+#define ALX_HW_INFO(_fmt, _args...) \
>+		ALX_HW_PRINTA(INFO, _fmt, ## _args)
>+
>+#define ALX_HW_DBG(_fmt, _args...) \
>+		ALX_HW_PRINTA(DEBUG, _fmt, ## _args)
>+
>
>We told you to get rid of your customized debug logging interfaces, yet all of
>this stuff is still there.
>
>+/* delay function */
>+#define US_DELAY(_hw, _n)	__US_DELAY(_n)
>+#define MS_DELAY(_hw, _n)	__MS_DELAY(_n)
>+#define __US_DELAY(_n)		udelay(_n)
>+#define __MS_DELAY(_n)		mdelay(_n)
>
>Useless wrappers for standard kernel interfaces, kill this.
>
>+#define DEBUG_INFO(_a, _b)
>+#define DEBUG_INFOS(_a, _b)
>
>Again we told you to get rid of this stuff.
>
>I suspect it's going to take may rounds of feedback before this driver is
>anywhere near ready for inclusion.
>
>Please just submit it to staging and let it cook there for a couple weeks in the
>interests of our sanity.

As you saw, should I do the two following steps?
1. I firstly try to submit code to linux-staging.git. 
2. After the driver have been accepted by  linux-staging.git, I submit to net-next.git again.

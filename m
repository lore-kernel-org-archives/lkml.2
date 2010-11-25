Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab0KYLK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:10:59 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:13554 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621Ab0KYLK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:10:57 -0500
Message-ID: <001c01cb8c91$6e93aef0$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Barry Song" <21cnbao@gmail.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        <andrew.chih.howe.khor@intel.com>, <qi.wang@intel.com>,
        <margie.foster@intel.com>, <yong.y.wang@intel.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>
References: <4CED023E.1070009@dsn.okisemi.com> <4CED13B5.5020309@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 6/17 v3] can: EG20T PCH: Fix endianness issue
Date: Thu, 25 Nov 2010 20:10:53 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 24, 2010 10:31 PM,  Marc Kleine-Budde wrote :

>> For easy to read, some sub-functions are created.
>>
>>
>> Modify complex "goto" to do~while.
>What about the next_flag in the rx_normal function? Can you get rid of
>it, too?
Subsequent Patch (11/17 Delete unnecessary ...) deletes "next_flag" in the rx_normal function.

---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

----- Original Message ----- 
From: "Marc Kleine-Budde" <mkl@pengutronix.de>
To: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>; "Wolfram Sang" <w.sang@pengutronix.de>; "Christian Pellegrin"
<chripell@fsfe.org>; "Barry Song" <21cnbao@gmail.com>; "Samuel Ortiz" <sameo@linux.intel.com>;
<socketcan-core@lists.berlios.de>; <netdev@vger.kernel.org>; <linux-kernel@vger.kernel.org>; "David S. Miller"
<davem@davemloft.net>; <andrew.chih.howe.khor@intel.com>; <qi.wang@intel.com>; <margie.foster@intel.com>;
<yong.y.wang@intel.com>; <kok.howg.ewe@intel.com>; <joel.clark@intel.com>
Sent: Wednesday, November 24, 2010 10:31 PM
Subject: Re: [PATCH net-next-2.6 6/17 v3] can: EG20T PCH: Fix endianness issue



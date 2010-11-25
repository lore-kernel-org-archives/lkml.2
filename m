Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab0KYMeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 07:34:15 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:22715 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225Ab0KYMeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 07:34:13 -0500
Message-ID: <002f01cb8c9d$103f7760$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: <andrew.chih.howe.khor@intel.com>, <socketcan-core@lists.berlios.de>,
        "Samuel Ortiz" <sameo@linux.intel.com>, <margie.foster@intel.com>,
        <netdev@vger.kernel.org>, "Christian Pellegrin" <chripell@fsfe.org>,
        <linux-kernel@vger.kernel.org>, <yong.y.wang@intel.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Wolfgang Grandegger" <wg@grandegger.com>, <qi.wang@intel.com>
References: <4CE2434B.5050701@dsn.okisemi.com>	<4CE27796.2000206@pengutronix.de>	<007401cb87b1$a773b3d0$66f8800a@maildom.okisemi.com>	<4CE64167.2030405@pengutronix.de> <003201cb8a02$f05b15e0$66f8800a@maildom.okisemi.com> <4CEA2986.4080607@pengutronix.de> <000b01cb8b6b$d7542a90$66f8800a@maildom.okisemi.com> <4CED0650.7030004@pengutronix.de> <001b01cb8c98$d06aaa00$66f8800a@maildom.okisemi.com> <4CEE51CA.8010402@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 v3] can: Topcliff: PCH_CAN driver: Add Flow control,
Date: Thu, 25 Nov 2010 21:34:09 +0900
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

On Thursday, November 25, 2010 9:08 PM, Marc Kleine-Budde wrote : 
> Why do you Read-Modify-Write for TX? Naively speaking you just need to
> push your Data into a Mail/IF/Whatever and push the send button.

I see.
I will implement this.

--
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

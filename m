Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab0J0AuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:50:13 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:29173 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757459Ab0J0AuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:50:12 -0400
Message-ID: <00de01cb7570$e88ca730$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Wolfgang Grandegger" <wg@grandegger.com>,
        "David Miller" <davem@davemloft.net>
Cc: <w.sang@pengutronix.de>, <chripell@fsfe.org>, <21cnbao@gmail.com>,
        <sameo@linux.intel.com>, <socketcan-core@lists.berlios.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <margie.foster@intel.com>,
        <socketcan-core-request@lists.berlios.de>
References: <4CC61B1B.3090602@dsn.okisemi.com>	<20101026.105206.15244527.davem@davemloft.net> <20101026.105545.200376685.davem@davemloft.net> <4CC71DA4.3020600@grandegger.com>
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build warnings
Date: Wed, 27 Oct 2010 09:50:08 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang and Marc,

On Wednesday, October 27, 2010 3:27 AM, Wolfgang Grandegger wrote:
> for the inconvenience, but the original author should have received it.
> Tomoya, could you (or somebody else) please also fix the remaining
> issues quickly?

"masa-korg@dsn.okisemi.com" left this project. and this mail-address will be deleted soon.
I (tomoya-linux@dsn.okisemi.com) have taken over "pch can drive" from him.

I will modify your comments ASAP.

---
Hi David,

On Wednesday, October 27, 2010 2:52 AM, David Miller wrote:
> There are still problems.
> 
> This is beyond frustrating.
> 
> > index 55ec324..2889e11 100755
> 
> Why does the pch_can.c file have execute permission in your tree?
> It doesn't in net-next-2.6 and that is what you should be generating
> patches against.
Sorry for the inconvenience.
After updating maintainer's comments and yours, I will post again.

---
Thanks, Tomoya(OKI SEMICONDUCTOR CO., LTD.)


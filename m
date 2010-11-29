Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab0K2B7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 20:59:36 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:42433 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772Ab0K2B7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 20:59:35 -0500
Message-ID: <002201cb8f69$11d30050$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: <andrew.chih.howe.khor@intel.com>, "Samuel Ortiz" <sameo@linux.intel.com>,
        <margie.foster@intel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <socketcan-core@lists.berlios.de>,
        <yong.y.wang@intel.com>, <kok.howg.ewe@intel.com>,
        "Wolfgang Grandegger" <wg@grandegger.com>, <joel.clark@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Christian Pellegrin" <chripell@fsfe.org>, <qi.wang@intel.com>
References: <4CEF150A.7080409@dsn.okisemi.com> <4CEF84BE.7000101@pengutronix.de> <4CEF864B.6080207@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 01/19 v5] can: EG20T PCH: Separate Interface Register(IF1/IF2)
Date: Mon, 29 Nov 2010 10:59:31 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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

On Friday, November 26, 2010 7:04 PM, Marc Kleine-Budde wrote:

>> nitpick: it's unusual to have leading whitespace in the patch description.

> maybe it's a problem of your mailer.
I can see the whitespace created patch by "git format-patch"
I show the head of patch below.

>From e53c63a8ff00c76f165e371511604f374451627b Mon Sep 17 00:00:00 2001
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date: Thu, 18 Nov 2010 09:18:15 +0900
Subject: [PATCH] CAN : Separate interface register from whole of register structure.
 CAN register of Intel PCH EG20T has 2 sets of interface register.
 To reduce whole of code size, separate interface register.
 As a result, the number of function also can be reduced.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/net/can/pch_can.c |  445 ++++++++++++++++++++-------------------------
 1 files changed, 201 insertions(+), 244 deletions(-)

.........

Since I have copied from the patch file directly, whitespace is inserted.
When next resubmitting, I will delete the whiletespace by hand.

---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab0KOIjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 03:39:51 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:36942 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837Ab0KOIjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 03:39:48 -0500
Message-ID: <00b301cb84a0$a8e67360$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Wolfgang Grandegger" <wg@grandegger.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Barry Song" <21cnbao@gmail.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <andrew.chih.howe.khor@intel.com>,
        <qi.wang@intel.com>, <margie.foster@intel.com>,
        <yong.y.wang@intel.com>, "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>
References: <4CCAA3D4.8070408@dsn.okisemi.com> <4CCAC4CD.7000503@pengutronix.de> <4CCAF517.2000409@pengutronix.de> <4CCB213A.2020206@grandegger.com>
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build warnings
Date: Mon, 15 Nov 2010 17:39:42 +0900
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

On Saturday, October 30, 2010 4:32 AM, Wolfgang Grandegger wrote:

> I'm missing CAN_CTRLMODE_3_SAMPLES here?
> 

This mode is not supported.

---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

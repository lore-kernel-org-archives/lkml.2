Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0KZAGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 19:06:31 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:42802 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750Ab0KZAGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 19:06:30 -0500
Message-ID: <000901cb8cfd$c667d860$66f8800a@maildom.okisemi.com>
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
References: <4CED037F.6060306@dsn.okisemi.com> <4CED0BF1.1060305@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 12/17 v3] can: EG20T PCH: Fix bit timing calculation issue
Date: Fri, 26 Nov 2010 09:06:25 +0900
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

On Wednesday, November 24, 2010 9:58 PM, Marc Kleine-Budde wrote :
> Masking here shouldn't be necessary but won't hurt, better play safe.

EG20T's baud rate pre-scalar register  is divided to 2 register BITT and BRPE.
Thus, This mask is necessary.
In fact, deleting this mask, it couldn't communicate correctly.

---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

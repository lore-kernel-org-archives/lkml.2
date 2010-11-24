Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0KXK6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:58:43 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:44240 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486Ab0KXK6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:58:42 -0500
Message-ID: <001a01cb8bc6$8da705b0$66f8800a@maildom.okisemi.com>
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
References: <4CECBFE3.8030402@dsn.okisemi.com> <4CECEC85.1050009@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 1/17 v2] can: EG20T PCH: Separate Interface Register(IF1/IF2)
Date: Wed, 24 Nov 2010 19:58:38 +0900
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

On Wednesday, November 24, 2010 7:44 PM,  Marc Kleine-Budde wrote :
> I failed to apply your series to david's net-2.6/master. Please resubmit.
I could confirm patch works well.

---
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
Sent: Wednesday, November 24, 2010 7:44 PM
Subject: Re: [PATCH net-next-2.6 1/17 v2] can: EG20T PCH: Separate Interface Register(IF1/IF2)



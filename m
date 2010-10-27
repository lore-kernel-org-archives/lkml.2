Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0J0E3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 00:29:30 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:19234 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060Ab0J0E3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 00:29:24 -0400
Message-ID: <002801cb758f$876aaf00$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <socketcan-core@lists.berlios.de>, <sameo@linux.intel.com>,
        <21cnbao@gmail.com>, <chripell@fsfe.org>, <w.sang@pengutronix.de>,
        <wg@grandegger.com>
Cc: "David Miller" <davem@davemloft.net>, <margie.foster@intel.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <yong.y.wang@intel.com>,
        <qi.wang@intel.com>
References: <4CC61B1B.3090602@dsn.okisemi.com> <20101026.105206.15244527.davem@davemloft.net>
Subject: can: About Socket CAN with MSI issue
Date: Wed, 27 Oct 2010 13:29:15 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have faced issue when our CAN diriver whose MSI is enabled, after installing the driver,
once remove the driver and install the driver again,
As a result, interupt handler of the driver is not called again.

Do you have any information or suggestion about the above issue?

As to the our latest CAN driver,
please refer to followoing patch posted by me.
[PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build warnings

Thanks, Tomoya(OKI SEMICONDUCTOR CO., LTD.)

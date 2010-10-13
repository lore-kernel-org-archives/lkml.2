Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083Ab0JMEX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 00:23:28 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:11824 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698Ab0JMEX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 00:23:26 -0400
Message-ID: <000701cb6a8e$60de6900$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: <qi.wang@intel.com>, <chripell@fsfe.org>, <kok.howg.ewe@intel.com>,
        <morinaga526@dsn.okisemi.com>, <joel.clark@intel.com>,
        <socketcan-core@lists.berlios.de>, <yong.y.wang@intel.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <margie.foster@intel.com>, <sameo@linux.intel.com>,
        <andrew.chih.howe.khor@intel.com>,
        "David Miller" <davem@davemloft.net>,
        "Wolfgang Grandegger" <wg@grandegger.com>
References: <002e01cb6486$2ed72cc0$66f8800a@maildom.okisemi.com>	<20101005.114506.184852374.davem@davemloft.net>	<000b01cb6503$962bc7f0$66f8800a@maildom.okisemi.com>	<20101005.200904.71120150.davem@davemloft.net>	<4CAC3D94.9010408@grandegger.com> <000c01cb69dc$5d2aaab0$66f8800a@maildom.okisemi.com> <4CB414A2.8020202@pengutronix.de>
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
Date: Wed, 13 Oct 2010 13:23:19 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 12, 2010 4:56 PM, Marc Kleine-Budde wrote :
> I just had a small peak at the datasheet. It seems you can implement the
> same scheme for rx as on the at91, if you enough rx buffers. In the at91
> driver I use 8+4 = 12 buffers for rx. Have a look at the driver, the rx
> path is documented.

Thank you for your suggestion.
This is valuable for us.
It seems the at91's Hw benabior similar to ours.
Using this method, we will implement and test.

Thanks, Ohtake(OKISemi)



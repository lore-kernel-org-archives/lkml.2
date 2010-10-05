Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857Ab0JEMJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:09:41 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:9431 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757085Ab0JEMJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:09:39 -0400
Message-ID: <002e01cb6486$2ed72cc0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: "Samuel Ortiz" <sameo@linux.intel.com>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "David S. Miller" <davem@davemloft.net>, <meego-dev@meego.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        <joel.clark@intel.com>, <kok.howg.ewe@intel.com>,
        <socketcan-core@lists.berlios.de>, <yong.y.wang@intel.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <margie.foster@intel.com>, <qi.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>,
        "Wolfgang Grandegger" <wg@grandegger.com>
References: <4C9C7C6F.1000003@dsn.okisemi.com>	<4CA4541F.5040804@grandegger.com>	<000401cb614f$c932c750$66f8800a@maildom.okisemi.com>	<4CA5D6D7.3010608@grandegger.com> <000401cb6477$25a0eba0$66f8800a@maildom.okisemi.com> <4CAB0732.3010400@pengutronix.de>
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
Date: Tue, 5 Oct 2010 21:09:30 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Tuesday, October 05, 2010 8:08 PM, Marc Kleine-Budde wrote:
> If FIFO is working you might also think about NAPI.

I think NAPI isn't necessary for our CAN driver.
NAPI is for high-speed networking.
CAN is NOT high-speed.

In fact, some accepted CAN drivers don't have NAPI.

Thanks, Ohtake(OKISemi)



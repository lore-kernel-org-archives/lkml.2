Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0K2ATT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 19:19:19 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:10774 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754270Ab0K2ATS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 19:19:18 -0500
Message-ID: <003c01cb8f5b$0f13e8b0$66f8800a@maildom.okisemi.com>
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
References: <4CEF178C.2050506@dsn.okisemi.com> <4CEF835C.7000304@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 06/19 v5] can: EG20T PCH: Fix endianness issue
Date: Mon, 29 Nov 2010 09:19:13 +0900
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

On Friday, November 26, 2010 6:52 PM, Marc Kleine-Budde wrote :

> In an OOM situation the system is under pressure anyway. On low end
> systems it not good to print a message to the log. AFAICS no other can
> driver does this.

Does the above mean it doesn't have to process for returned value of
pch_can_rx_msg_lost  like below?
> +   pch_can_rx_msg_lost(ndev, obj_num);
> +   rcv_pkts++;
> +   quota--;

> AFAICS no other can driver does this.
I can see ti_hecc.c calls dev_err when alloc_can_err_skb fails.

Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.


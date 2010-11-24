Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0KXLXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:23:43 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:11589 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095Ab0KXLXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:23:42 -0500
Message-ID: <005201cb8bca$0c110dd0$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Barry Song" <21cnbao@gmail.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <andrew.chih.howe.khor@intel.com>,
        <joel.clark@intel.com>, <kok.howg.ewe@intel.com>,
        <margie.foster@intel.com>
References: <4CECC07E.40804@dsn.okisemi.com> <4CECEE1E.9030201@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 8/17 v2] can: EG20T PCH: Change Copyright and module description
Date: Wed, 24 Nov 2010 20:23:40 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
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

On Wednesday, November 24, 2010 7:51 PM, Marc Kleine-Budde wrote:

> Did your mailer spawn some extra spaces here? The header of your mail
> tells me:
> "User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.1.15)
> Gecko/20101027 Thunderbird/3.0.10"
> I strongly suggest to use git send-email.

Sorry, we also want to use "git send-email".
However , in our network environment, it couldn't send patch using "git send-email " anyway.

According to kernel documentation, I have set thunderbird configuration with correctly.

>  module_exit(pch_can_pci_exit);
>  -MODULE_DESCRIPTION("Controller Area Network Driver");
>
You are right.
Confirming my tx mail box of thunderbird, I can see the invalid space.
I don't know the reason why.


---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab0JFDHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:07:21 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:17976 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758351Ab0JFDHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:07:20 -0400
Message-ID: <000b01cb6503$962bc7f0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "David Miller" <davem@davemloft.net>
Cc: <mkl@pengutronix.de>, <sameo@linux.intel.com>, <chripell@fsfe.org>,
        <meego-dev@meego.com>, <morinaga526@dsn.okisemi.com>,
        <joel.clark@intel.com>, <kok.howg.ewe@intel.com>,
        <socketcan-core@lists.berlios.de>, <yong.y.wang@intel.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <margie.foster@intel.com>, <qi.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <wg@grandegger.com>
References: <000401cb6477$25a0eba0$66f8800a@maildom.okisemi.com><4CAB0732.3010400@pengutronix.de><002e01cb6486$2ed72cc0$66f8800a@maildom.okisemi.com> <20101005.114506.184852374.davem@davemloft.net>
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
Date: Wed, 6 Oct 2010 12:07:15 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wednesday, October 06, 2010 3:45 AM, David Miller wrote,
> We encourage all new drivers that can use NAPI to do so, just because
> recent driver submissions do not do this doesn't mean we should
> continue such a mistake ;-)

I understand NAPI's merit.
But, since we have already implemented without NAPI.
If possible, we don't want to use NAPI.

Does your mail mean, for accepting upstream, NAPI is essential for CAN driver ?
If essential, we will just do.

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "David Miller" <davem@davemloft.net>
To: <masa-korg@dsn.okisemi.com>
Cc: <mkl@pengutronix.de>; <sameo@linux.intel.com>; <chripell@fsfe.org>; <meego-dev@meego.com>;
<morinaga526@dsn.okisemi.com>; <joel.clark@intel.com>; <kok.howg.ewe@intel.com>; <socketcan-core@lists.berlios.de>;
<yong.y.wang@intel.com>; <linux-kernel@vger.kernel.org>; <netdev@vger.kernel.org>; <margie.foster@intel.com>;
<qi.wang@intel.com>; <andrew.chih.howe.khor@intel.com>; <wg@grandegger.com>
Sent: Wednesday, October 06, 2010 3:45 AM
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35


> From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
> Date: Tue, 5 Oct 2010 21:09:30 +0900
>
> > On Tuesday, October 05, 2010 8:08 PM, Marc Kleine-Budde wrote:
> >> If FIFO is working you might also think about NAPI.
> >
> > I think NAPI isn't necessary for our CAN driver.
> > NAPI is for high-speed networking.
> > CAN is NOT high-speed.
> >
> > In fact, some accepted CAN drivers don't have NAPI.
>
> NAPI is not just for performance concerns.
>
> It greatly simplifies the locking since all packet processing paths
> run only in software interrupt context, never in hardware interrupt
> context.
>
> We encourage all new drivers that can use NAPI to do so, just because
> recent driver submissions do not do this doesn't mean we should
> continue such a mistake ;-)
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0IPX4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:56:03 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:30024 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475Ab0IPX4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:56:01 -0400
Message-ID: <000401cb55fa$b6709e90$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Wolfgang Grandegger" <wg@grandegger.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Barry Song" <21cnbao@gmail.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <meego-dev@meego.com>,
        <andrew.chih.howe.khor@intel.com>, <qi.wang@intel.com>,
        <gregkh@suse.de>, <yong.y.wang@intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        <arjan@linux.intel.com>, "Marc Kleine-Budde" <mkl@pengutronix.de>
References: <4C8E1773.9090000@dsn.okisemi.com> <4C8E3FDE.2000002@pengutronix.de> <002601cb557c$69292180$66f8800a@maildom.okisemi.com> <4C91DF20.7040807@grandegger.com>
Subject: Re: [MeeGo-Dev][PATCH v2] Topcliff: Update PCH_CAN driver to 2.6.35
Date: Fri, 17 Sep 2010 08:55:54 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang Grandegger

According to your policy, we will remove filter processing so that
all packets can be received.

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Wolfgang Grandegger" <wg@grandegger.com>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Marc Kleine-Budde" <mkl@pengutronix.de>; <arjan@linux.intel.com>; "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>;
<yong.y.wang@intel.com>; <gregkh@suse.de>; <qi.wang@intel.com>; <andrew.chih.howe.khor@intel.com>;
<meego-dev@meego.com>; <linux-kernel@vger.kernel.org>; <netdev@vger.kernel.org>; <socketcan-core@lists.berlios.de>;
"Samuel Ortiz" <sameo@linux.intel.com>; "Barry Song" <21cnbao@gmail.com>; "Christian Pellegrin" <chripell@fsfe.org>;
"Wolfram Sang" <w.sang@pengutronix.de>; "David S. Miller" <davem@davemloft.net>
Sent: Thursday, September 16, 2010 6:10 PM
Subject: Re: [MeeGo-Dev][PATCH v2] Topcliff: Update PCH_CAN driver to 2.6.35


> On 09/16/2010 10:51 AM, Masayuki Ohtake wrote:
> > Hi Marc,
> >
> >> - Please remove rx-filter handling from the driver completely, simply
> >>   receive every can frame
> >
> > This rx-filter function is for Topcliff's CAN HW function.
> > This function is important.
> > Could you tell us the reason why should we remove filter function ?
>
> We do not (yet) support the filtering capability of the CAN controller
> hardware. Therefore please configure the hardware filter to accept *any*
> CAN message like all other drivers do, e.g.:
>
> http://lxr.linux.no/#linux+v2.6.35.4/drivers/net/can/sja1000/sja1000.c#L249
>
> Wolfgang.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab0JEKWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:22:04 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:7673 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755244Ab0JEKWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:22:01 -0400
Message-ID: <000401cb6477$25a0eba0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Wolfgang Grandegger" <wg@grandegger.com>
Cc: <andrew.chih.howe.khor@intel.com>, <qi.wang@intel.com>,
        <margie.foster@intel.com>, <netdev@vger.kernel.org>,
        <yong.y.wang@intel.com>, <linux-kernel@vger.kernel.org>,
        <socketcan-core@lists.berlios.de>, <kok.howg.ewe@intel.com>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>, <meego-dev@meego.com>,
        "David S. Miller" <davem@davemloft.net>, <joel.clark@intel.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>
References: <4C9C7C6F.1000003@dsn.okisemi.com>	<4CA4541F.5040804@grandegger.com> <000401cb614f$c932c750$66f8800a@maildom.okisemi.com> <4CA5D6D7.3010608@grandegger.com>
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
Date: Tue, 5 Oct 2010 19:21:56 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang,

I could confirm below.
With FIFO mode, it is able to receive packet with in-order.
We are now implementing FIFO mode.

Thanks, Ohtake(OKISemi)

----- Original Message ----- 
From: "Wolfgang Grandegger" <wg@grandegger.com>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: <andrew.chih.howe.khor@intel.com>; <qi.wang@intel.com>; <margie.foster@intel.com>; <netdev@vger.kernel.org>;
<yong.y.wang@intel.com>; <linux-kernel@vger.kernel.org>; <socketcan-core@lists.berlios.de>; <kok.howg.ewe@intel.com>;
"Christian Pellegrin" <chripell@fsfe.org>; "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>; <meego-dev@meego.com>;
"David S. Miller" <davem@davemloft.net>; <joel.clark@intel.com>; "Samuel Ortiz" <sameo@linux.intel.com>
Sent: Friday, October 01, 2010 9:40 PM
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35


> On 10/01/2010 12:02 PM, Masayuki Ohtake wrote:
> > Hi Wolfgang Grandegger,
> >
> > Thank you for your comments.
> >
> > We will modify and re-post ASAP.
> >
> > I have a comment about below.
> >> In this driver you are using just *one* RX object. This means that the
> >> CPU must handle new messages as quickly as possible otherwise message
> >> losses will happen, right?. For sure, this will not make user's happy.
> >> Any chance to use more RX objects in FIFO mode?
> >
> > In case implementing with FIFO mode,
> > received packets may be our of order.
>
> Hm, FIFO means "First in First out"! It might be tricky to implement,
> though.
>
> > Because our CAN register access is slow.
> >
> > I am confirming our CAN HW spec and the possibility of our-of-order.
>
> I don't understand?
>
> Wolfgang.
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



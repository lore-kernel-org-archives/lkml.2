Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab0KQDAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 22:00:43 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:18844 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370Ab0KQDAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 22:00:42 -0500
Message-ID: <00d101cb8603$9e2f3970$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: <w.sang@pengutronix.de>, "David Miller" <davem@davemloft.net>,
        <wg@grandegger.com>
Cc: <andrew.chih.howe.khor@intel.com>, <sameo@linux.intel.com>,
        <margie.foster@intel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <socketcan-core@lists.berlios.de>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>,
        <yong.y.wang@intel.com>, <chripell@fsfe.org>, <qi.wang@intel.com>
References: <4CE2EC13.9090707@grandegger.com><20101116.124325.116396459.davem@davemloft.net><20101116210716.GA19893@pengutronix.de> <20101116.131008.212663108.davem@davemloft.net>
Subject: Re: [PATCH net-next-2.6 v4] can: Topcliff: PCH_CAN driver: Add Flow control/Fix Endianess issue/Separate IF register/Enumerate LEC macro/Move MSI processing/Use BIT(X)/Change Message Object index/Add prefix PCH_
Date: Wed, 17 Nov 2010 12:00:37 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David Miller,

I see, I just have to obey your saying.
I will split our patch per issue/indicated item and re-submit to you.

Thanks,
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
----- Original Message ----- 
From: "David Miller" <davem@davemloft.net>
To: <w.sang@pengutronix.de>
Cc: <wg@grandegger.com>; <tomoya-linux@dsn.okisemi.com>; <andrew.chih.howe.khor@intel.com>; <masa-korg@dsn.okisemi.com>;
<sameo@linux.intel.com>; <margie.foster@intel.com>; <netdev@vger.kernel.org>; <linux-kernel@vger.kernel.org>;
<socketcan-core@lists.berlios.de>; <kok.howg.ewe@intel.com>; <joel.clark@intel.com>; <yong.y.wang@intel.com>;
<chripell@fsfe.org>; <qi.wang@intel.com>
Sent: Wednesday, November 17, 2010 6:10 AM
Subject: Re: [PATCH net-next-2.6 v4] can: Topcliff: PCH_CAN driver: Add Flow control/Fix Endianess issue/Separate IF
register/Enumerate LEC macro/Move MSI processing/Use BIT(X)/Change Message Object index/Add prefix PCH_


> From: Wolfram Sang <w.sang@pengutronix.de>
> Date: Tue, 16 Nov 2010 22:07:16 +0100
>
> > On Tue, Nov 16, 2010 at 12:43:25PM -0800, David Miller wrote:
> >> From: Wolfgang Grandegger <wg@grandegger.com>
> >> Date: Tue, 16 Nov 2010 21:39:47 +0100
> >>
> >> > Please take into account that this patch got accepted by accident
> >> > (because the maintainer did not respond properly in time). At that time
> >> > the driver was incomplete, not ready for mainline and did not even work
> >> > properly. Therefore it makes little sense to debug or even bisec these
> >> > changes. Just for that reason I made an exemption and added my
> >> > "Acked-by". Hope you can share my arguments.
> >>
> >> You don't put stupid on top of stupid and justify the latter using
> >> the former.
> >
> > Is reverting the incomplete driver an option?
>
> I told everyone that the plan was that we had several months
> to fix this, and that's what we should do.
>
> But yes if people are going to be maximally difficult about this and
> refuse to split up the bug fixes, I will have to regrettably revert
> the driver.
>
> But let's avoid that if we can.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


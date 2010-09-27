Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073Ab0I0Phn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:37:43 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:24981 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755305Ab0I0Phl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:37:41 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: LFblAREVM1kvuBolREmGx3Oi.53gmAfvIPw2f4555FYRF0n
 M9IW1wKT6shDvY00jeT2jtAkRy9wIccSvlVGZb4CB.g6K_iyLxejNnzaeNc_
 gx71EAM46Zyr3fn8LBR9ygRJcwlBwI1XUwWRfDBRDM5ZgISLuYTkkLVSlyL9
 n0NChQmUUdg.iZMPVm6cHdahVl4gfsj1qkOIlPC4ie2PPCoEdRW0pbqGDjfF
 c
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 27 Sep 2010 10:37:35 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Christian Riesch <christian@riesch.at>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, john stultz <johnstul@us.ibm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
In-Reply-To: <4C9BC7CE.8020400@riesch.at>
Message-ID: <alpine.DEB.2.00.1009271035110.9258@router.home>
References: <cover.1285261533.git.richard.cochran@omicron.at> <alpine.DEB.2.00.1009231238170.2962@router.home> <1285268380.2587.11.camel@localhost.localdomain> <alpine.DEB.2.00.1009231402420.2962@router.home> <1285273684.2587.92.camel@localhost.localdomain>
 <alpine.DEB.2.00.1009231533040.7522@router.home> <20100923223417.4ed62e5b@lxorguk.ukuu.org.uk> <4C9BC7CE.8020400@riesch.at>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010, Christian Riesch wrote:

> > > It implies clock tuning in userspace for a potential sub microsecond
> > > accurate clock. The clock accuracy will be limited by user space
> > > latencies and noise. You wont be able to discipline the system clock
> > > accurately.
> >
> > Noise matters, latency doesn't.
>
> Well put! That's why we need hardware support for PTP timestamping to reduce
> the noise, but get along well with the clock servo that is steering the PHC in
> user space.

Even if I buy into the catch phrase above: User space is subject to noise
that the in kernel code is not. If you do the tuning over long intervals
then it hopefully averages out but it still causes jitter effects that
affects the degree of accuracy (or sync) that you can reach. And the noise
varies with the load on the system.




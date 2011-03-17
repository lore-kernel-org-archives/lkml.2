Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954Ab1CQEKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 00:10:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1CQEKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 00:10:04 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=uAWN9GZ2uBAA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=XeCQIahXF33ET73GQ0QA:9 a=rdXzJ7OTbCUIyHrPd6suBdyZVuQA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 17 Mar 2011 00:10:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: what is the better method to do tsc synchronized check?
Message-ID: <20110317041001.GC14675@home.goodmis.org>
References: <AANLkTi=HB7s-VpMAZmNBPgvQadtN9tg91pFY-=atAWsM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=HB7s-VpMAZmNBPgvQadtN9tg91pFY-=atAWsM@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Cc's of people that might help you. ]

-- Steve

On Wed, Mar 16, 2011 at 10:56:25PM -0400, Luming Yu wrote:
> Hi there,
> 
> I tested two different methods to do TSC sync check on a Sandy Bridge system.
> The first TSC sync check method is from upstream -38-rc that considers
> TSC is synced.
> The second TSC sync check method is from a 2.6.18 based  kernel that
> considers TSC
> is NOT synced on the Sandy Bridge system. (I modified sync_tsc() to
> just test (not modify TSC) on
> the cpu being tested.)
> 
> [root@intel-sugarbay-DO-01 kernel]# dmesg | grep -i synchroniz
> CPU 1: synchronized TSC with CPU 0 (last diff 29 cycles, maxerr 276 cycles)
> CPU 2: synchronized TSC with CPU 0 (last diff 32 cycles, maxerr 280 cycles)
> CPU 3: synchronized TSC with CPU 0 (last diff 31 cycles, maxerr 284 cycles)
> 
> Do you guy think we need to take 2.6.18-based tsc sync testing method
> rather than the current one in upstream?
> 
> Any inputs are appreciated.
> 
> 
> Thanks
> Luming
> --

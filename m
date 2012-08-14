Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2HNIma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:42:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:57002 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2HNIm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:42:28 -0400
Date: Tue, 14 Aug 2012 10:42:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: viresh kumar <viresh.kumar@linaro.org>
cc: linux-tip-commits@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        namhyung@kernel.org, paulmck@linux.vnet.ibm.com,
        Amit Kucheria <amit.kucheria@linaro.org>, steve.bannister@arm.com
Subject: Re: [tip:smp/hotplug] watchdog: Use hotplug thread infrastructure
In-Reply-To: <CAOh2x=ny-76y0S=Nukz-Gz7OUZT19evXSVUWmFG2KdLoHcN6wQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1208141041310.32033@ionos>
References: <20120716103948.563736676@linutronix.de> <tip-bcd951cf10f24e341defcd002c15a1f4eea13ddb@git.kernel.org> <CAOh2x=ny-76y0S=Nukz-Gz7OUZT19evXSVUWmFG2KdLoHcN6wQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012, viresh kumar wrote:

> On Mon, Aug 13, 2012 at 8:43 PM, tip-bot for Thomas Gleixner
> <tglx@linutronix.de> wrote:
> > Commit-ID:  bcd951cf10f24e341defcd002c15a1f4eea13ddb
> > Gitweb:     http://git.kernel.org/tip/bcd951cf10f24e341defcd002c15a1f4eea13ddb
> > Author:     Thomas Gleixner <tglx@linutronix.de>
> > AuthorDate: Mon, 16 Jul 2012 10:42:38 +0000
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Mon, 13 Aug 2012 17:01:07 +0200
> >
> > watchdog: Use hotplug thread infrastructure
> 
> Hi Thomas,
> 
> I am maintaining http://git.linaro.org/gitweb?p=arm/big.LITTLE/mp.git;a=summary
> linaro tree for big.LITTLE MP work. I had a branch
> per-cpu-thread-hotplug-v3-fixed
> with your stuff in it + Paul's fix.
> 
> I was rebasing it over 3.6-rc1 and got conflicts, actually a routine is added in
> kernel/watchdog.c file, which uses functions removed in your patch:
> 
> 
> commit 45226e944ce071d0231949f2fea90969437cd2dc
> Author: Sameer Nanda <snanda@chromium.org>
> Date:   Mon Jul 30 14:40:00 2012 -0700
> 
>     NMI watchdog: fix for lockup detector breakage on resume

This patch got reverted in mainline. See commit commit 300d3739
(Revert "NMI watchdog: fix for lockup detector breakage on resume")

So nothing to fix there.

Thanks,

	tglx


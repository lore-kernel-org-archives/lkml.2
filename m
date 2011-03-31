Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab1CaIHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 04:07:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48990 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757146Ab1CaIHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 04:07:06 -0400
Date: Thu, 31 Mar 2011 10:06:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110331080634.GA18022@elte.hu>
References: <20110318101512.GA15375@n2100.arm.linux.org.uk>
 <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
 <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
 <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
 <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
 <alpine.LFD.2.00.1103302255280.28032@xanadu.home>
 <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm>
 <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nicolas Pitre <nico@fluxnic.net> wrote:

> On Wed, 30 Mar 2011, david@lang.hm wrote:
> 
> > back in the early days of the PCs, different systems from different vendors
> > had different bus types, peripherals at different addresses, etc. that didn't
> > make all of those vendors systems different architectures, instead those
> > things were varients of the x86 architecture.
> 
> Most of them didn't survive.  That really helps.

That's not the point, 99% of the current ARM boards will not 'survive' either, 
10-20 years down the road.

I think you missed David's main point: life inevitably went on and few of the 
old x86 hardware 'survived' physically, but past hardware versions have not 
littered the kernel source with half a million lines of source code in the 
process ...

Having strong, effective platform abstractions inside the kernel really helps 
even if the hardware space itself is inevitably fragmented: both powerpc and 
x86 has shown that. Until you realize and appreciate that you really have not 
understood the problem i think.

Thanks,

	Ingo

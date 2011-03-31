Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab1CaMEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:04:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:57487 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab1CaMEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:04:37 -0400
Date: Thu, 31 Mar 2011 14:04:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Ingo Molnar <mingo@elte.hu>, Nicolas Pitre <nico@fluxnic.net>,
        david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <20110331083044.GB14323@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1103311359320.22418@localhost6.localdomain6>
References: <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com> <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
 <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm> <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <20110331080634.GA18022@elte.hu>
 <20110331083044.GB14323@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Russell King - ARM Linux wrote:

> On Thu, Mar 31, 2011 at 10:06:34AM +0200, Ingo Molnar wrote:
> > Having strong, effective platform abstractions inside the kernel really helps 
> > even if the hardware space itself is inevitably fragmented: both powerpc and 
> > x86 has shown that. Until you realize and appreciate that you really have not 
> > understood the problem i think.
> 
> No, I think it is the other way around.  Folk like me and Nicolas over
> the last ten years have put considerable amounts of effort into trying
> to keep the ARM support code as clean and maintainable as possible.
> 
> That is true of the common ARM stuff, but there's no way we can do this
> for all SoC support - there aren't the hours in the day to provide such

That's what I said. You and Nicholas wont scale.

> a wide oversight.  That's why we have SoC maintainers, and the SoC
> maintainers have the responsibility to sort out their own sub-trees.

But the current SoC maintainer model does not work either. The SoC
maintainers care about their sandbox and have exactly zero incentive
to look at the overall picture, e.g reuse of code for the same IP
blocks, better abstraction mechanisms etc. 

Therefor you need a team of experienced kernel developers which are
NOT associated with a particular vendor who are able to tame that SoC
crowd and work closely with you and Nicholas to keep stuff in sync.

Thanks,

	tglx

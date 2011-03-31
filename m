Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964803Ab1CaPCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:02:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:59381 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758077Ab1CaPB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:01:59 -0400
Date: Thu, 31 Mar 2011 17:01:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Hilman <khilman@ti.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Nicolas Pitre <nico@fluxnic.net>,
        david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <87d3l7jqpr.fsf@ti.com>
Message-ID: <alpine.LFD.2.00.1103311647300.22418@localhost6.localdomain6>
References: <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com> <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
 <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm> <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <20110331080634.GA18022@elte.hu>
 <20110331083044.GB14323@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1103311359320.22418@localhost6.localdomain6> <87d3l7jqpr.fsf@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Kevin Hilman wrote:

> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > But the current SoC maintainer model does not work either. The SoC
> > maintainers care about their sandbox and have exactly zero incentive
> > to look at the overall picture, e.g reuse of code for the same IP
> > blocks, better abstraction mechanisms etc. 
> 
> zero incentive?  that's a bit strong, IMO.
> 
> That may be true for some SoCs, it's not really fair as a sweeping
> statement.

Fair enough, but it's the perception in general.

> Conference (ELC, US and Europe.)  Especially as IP blocks are reused
> across SoC families, abstractions like runtime PM are the only way to
> keep the SoC specifics of PM out of the common driver.

Right, I know that these things happen, but at the same time the sheer
amount of stuff flowing in makes it hard that these infrastructure
stuff really works out. And we are only at the beginning of the big
shuffle "code in to mainline" game.

After cleaning up the whole irq stuff across the tree I can tell you,
that the mess is non-linear growing with the number of instances.

You can see the patterns which are:
    - copy and paste
    - introduce different bugs
    - add more abuse

That's what I'm really concerned about.

> Yes, ARM SoC maintainers have to make up some ground.  But compare this
> to just a couple years ago where the common complaint was "why aren't
> embedded SoC people contributing code to mainline", and you'll see we
> have come a long way.

Well, code comes in, which is progress. But we need to figure out how
to deal with the increasingly growing flood before we drown in it.

Thanks,

	tglx


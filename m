Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab1CaSfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:35:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:40963 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758781Ab1CaSfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:35:18 -0400
Date: Thu, 31 Mar 2011 20:34:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nicolas Pitre <nico@fluxnic.net>
cc: david@lang.hm, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <alpine.LFD.2.00.1103311218240.28032@xanadu.home>
Message-ID: <alpine.LFD.2.00.1103312019350.22418@localhost6.localdomain6>
References: <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com> <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
 <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm> <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <20110331080634.GA18022@elte.hu>
 <20110331083044.GB14323@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1103310855450.29543@asgard.lang.hm> <alpine.LFD.2.00.1103311218240.28032@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Nicolas Pitre wrote:
> On Thu, 31 Mar 2011, david@lang.hm wrote:
> 
> > I think that part of the issue is that when Linus points out a problem, the
> > response isn't "we agree and are working on it, here's what we are doing",
> > instead it seems to be mostly "there is no problem, this is just because there
> > is so much variation in ARM"
>
> If prominent people looking at this from the side line continue bashing 
> at those who are both feet in the mud trying to contain the flood rather 
> than actually helping then nothing will change.  Instead this only 
> creates despair and the splashed people may simply decide to throw in 
> the towel, at which point things will collapse for real.  In reality, 
> the system has been going as it is for quite a while and with more or 
> less the same level of intensity.  And the fact is that _users_ of the 
> ARM kernel are not complaining.  Things are far from being perfect, but 
> so far things have been "good enough" for the majority of the people 
> involved, and improvements are constantly being worked on with the men 
> power available.

And that's the whole point why I was ranting in the first place. I
know that there are clever folks working on the solution, but it's
entirely clear to me, that they are simply not enough compared to the
massive inbound flood. So neither you nor Russell can cope with it,
you simply do not scale. That's why I suggested that the ARM community
needs to push competent man power into this.

You say the concept of subarch maintainers is working quite well. That
depends on the definition of working. It works in terms of users can
use it, but it does not work from a maintainability POV.

Nobody wants to bash on those who are working on it, but IMNSHO the
current way is running into an utter nightmare even w/o you and
Russell throwing in the towel.

I went through quite a few iterations of large scale cleanups, so I
know how you feel.

Thanks,

	tglx



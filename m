Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab1CaNCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:02:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36678 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab1CaNCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:02:36 -0400
Date: Thu, 31 Mar 2011 14:01:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        Dave Airlie <airlied@gmail.com>, david@lang.hm,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110331130123.GB17547@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home> <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <AANLkTikV5OMifKjWRVdtJLEcxcZ56jrjWLYJBX89pHQ0@mail.gmail.com> <alpine.LFD.2.00.1103310012500.28032@xanadu.home> <20110331105440.42692165@lxorguk.ukuu.org.uk> <20110331105000.GC14323@n2100.arm.linux.org.uk> <1301575101.10659.132.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301575101.10659.132.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 01:38:21PM +0100, Catalin Marinas wrote:
> On Thu, 2011-03-31 at 11:50 +0100, Russell King - ARM Linux wrote:
> > Given this thread, I've lost the motivation to continue with it because
> > it's just going to cause more 'pointless churn' and end up annoying
> > Linus even more.
> 
> I don't think the criticism was directed at the core ARM code that you
> maintain (Ingo and others even praised it). I also don't think that you
> stopping maintaining it would help in any way with this situation.
> 
> We probably shouldn't take criticism personally. Linus has some points
> which the ARM community is aware of already since there is ongoing work
> for consolidating the platform code (recent v2p patches, SMP-on-UP, FDT
> and probably more will come) only that this won't happen overnight. If
> you stop merging any of these, there's definitely no way out (other than
> doing the work separately for the next two years and replacing the
> arch/arm in a single pull request).

But are we going to be allowed to continue this effort without being
constantly blamed for "pointless churn" all the time?  I don't think
so, so it may well be better to give up with pushing stuff into mainline
for two years, and then do a massive re-merge as a single major "replace
everything".

I don't like the idea, but I don't see much alternative.

And since Linus' whinge about ARM defconfigs, I really *hate* merging
anything with *any* defconfig changes in - as a result, I don't
particularly want to deal with ARM defconfig changes anymore.  I'm sure
they'll make Linus explode about it again in the near future.  That's
why this time around, I kept them in a separate branch in case Linus
refused to pull them.

And again, as a result of this thread I've given up for the time being
on the idea of continuing to consolidate the ARM Integrator/Versatile/
Realview/Versatile Express code.  I just don't see the point of wasting
time trying to consolidate stuff if it's just going to be used against
us in terms of diffstat percentages and churn complaints.

Just look at the removal of AAEC2000, LH7A40x and 2000 lines from the
mach-types file removed 6000 lines, which in itself is about the number
of lines of change submitted during the last merge window for any one
non-ARM architecture.  At this point in time with this complaint, I've
absolutely no idea why I bothered to do that.  I should've left it well
alone and then the diffstat percentage would've been smaller.  After
all, it's "pointless churn".

Yes, I'm severely hacked off and fed up with this.   Whatever we do will
ultimately be used against us in one way or another.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab1CaEJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 00:09:32 -0400
Received: from relais.videotron.ca ([24.201.245.36]:54782 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1CaEJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 00:09:31 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 31 Mar 2011 00:09:30 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-reply-to: <AANLkTinE7EDbV8hrYZWBxgvwOxdPMLoS0Y57PSm04rvM@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1103302319290.28032@xanadu.home>
References: <20110317183048.GW7258@atomide.com>
 <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk>
 <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <20110331001502.GB6680@n2100.arm.linux.org.uk>
 <AANLkTinE7EDbV8hrYZWBxgvwOxdPMLoS0Y57PSm04rvM@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Linus Torvalds wrote:

> Umm. The actual stats are still:
> 
>  1349 files changed, 62230 insertions(+), 33993 deletions(-)
> 
> which is sad. And the end result speaks for itself: this is lines per
> architecture:
> 
>   ...
>   124022 total arch/sh
>   124418 total arch/sparc
>   181997 total arch/m68k
>   246717 total arch/mips
>   254785 total arch/x86
>   370912 total arch/powerpc
>   732732 total arch/arm
> 
> notice how ARM ends up being in a class of its own. This is a PROBLEM.

OK let's think of it in terms of a problem.  How do _we_ fix it?  Maybe 
we can change the Linux license and enforce some policies on the 
hardware manufacturers imposing them to conform to a strict model before 
they are allowed to use Linux. Do you think you can have such an 
influence on them?  I really don't think I do.

Or maybe we can tell to all those crazy people to get together and stop 
trying to differentiate themselves otherwise we'll just ignore them?  
That could be an option, those people will go away, and embedded Linux 
will go back underground like it used to be.  Wouldn't that be 
wonderful?

> And ARM fanbois can say "oh, but arm is special" all they want, but
> they need to realize that the lack of common platform for ARM is a
> real major issue. It's not a "feature", and I'm sorry, but anybody who
> calls x86 "peanuts" is a moron and should be ashamed of himself.
> Instead of trying to feel superior, those people should feel like
> pariah.

Oh come on.  You just provided actual numbers above showing that ARM is 
simply fscked up (your words) compared to X86.  I would be curious to 
know what people like tglx who did significant work on both 
architectures actually think of X86 relative to ARM when it comes to 
kernel maintenance.

No one is saying there is no problem.  There is _indeed_ a problem in ARM 
land.  But this is actually a _hardware_ problem that no one refutes.  
On the software side I'd say that we're struggling but still coping 
relatively well with it given the actual hardware jungle out there.  It 
is not like if _we_ could do something about _that_.

> The fact that x86 has a platform, and people have cared about
> compatibility, and actually gets things to work with less code is a
> good thing. I know ARM people who think that x86 is an "ugly"
> architecture. But the fact is, of all the architectures out there, ARM
> right now is the ugliest BY FAR. Exactly because of people who don't
> seem to understand that this kind of crap is a problem.

No disagreement here.  Certainly not from my side. I would much prefer 
to have only one or two ARM variants to deal with like in the old days 
when only a very few ARM vendors were relevant.  But the reality has 
changed, and unless we start boycotting those who try to be different 
just because they can, I don't think we have much choice but to cope.  
And so far we do cope remarquably well given the diversity involved.

Things can be improved and they are indeed being improved every merge 
window.  But at the same time there is a new and different SOC to 
support each merge window as well which just can't be fitted in the 
existing numerous SOC models.  And this is really frustrating indeed 
because there is simply no magic solution and yet more code needs to be 
written and reviewed again.

At least we managed to isolate the crap into separate directories and 
try hard for one vendor not to screw up the other ones.


Nicolas

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab1CaWt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 18:49:29 -0400
Received: from relais.videotron.ca ([24.201.245.36]:24743 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab1CaWt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 18:49:28 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_AINh8tpyRSxXIxb+njnndA)"
Date: Thu, 31 Mar 2011 18:49:11 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, david@lang.hm,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-reply-to: <AANLkTi=kbozPcWEk9wVZb7emSWx48BJQS=7Uzaya9Lor@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1103311649450.28032@xanadu.home>
References: <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
 <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
 <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
 <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
 <alpine.LFD.2.00.1103302255280.28032@xanadu.home>
 <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm>
 <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
 <20110331080634.GA18022@elte.hu>
 <20110331083044.GB14323@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1103310855450.29543@asgard.lang.hm>
 <20110331164539.GB19452@n2100.arm.linux.org.uk>
 <AANLkTi=tyifvJU-hhdd7gT74GMctrCbQBdUAoEaRXOCy@mail.gmail.com>
 <alpine.LFD.2.00.1103311429590.28032@xanadu.home>
 <AANLkTi=kbozPcWEk9wVZb7emSWx48BJQS=7Uzaya9Lor@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Content-id: <alpine.LFD.2.00.1103311805580.28032@xanadu.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_AINh8tpyRSxXIxb+njnndA)
Content-id: <alpine.LFD.2.00.1103311805581.28032@xanadu.home>
Content-type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-transfer-encoding: 8BIT

On Thu, 31 Mar 2011, Linus Torvalds wrote:

> On Thu, Mar 31, 2011 at 12:25 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> >
> > So we need help!  If core kernel people could get off their X86 stool
> > and get down in the ARM mud to help sort out this mess that would be
> > really nice (thanks tglx).  Until then all that the few of us can do is
> > to contain the flood and hope for the best, and so far things being as
> > they are have still worked surprisingly well in practice for users.  If
> > compensation is a concern then I think Linaro might be able to arrange
> > something.
> 
> The thing is, maintainers don't scale.

True.  My remark about core kernel people still stands though.

> The only way to get quality code is to try to improve the quality from
> the "leaf nodes", because otherwise you'll always end up playing
> catch-up. You'll get new bad code faster than you can clean it up.

Leaf nodes on ARM are people coming from corporate background with the 
old school software development methodologies.  They do it as a _job_ 
first and foremost.  They only work on Linux because that's what their 
boss assigned them to. Don't get me wrong: that doesn't mean they are 
bad people.  Simply that they are not into it for the public recognition 
(or flaming) from their peers.  Once their code works they lose interest 
and move on.  That mindset is extremely hard to change and take time, on 
a scale of years.  Much more time than required to produce the code 
needed to support that new SOC out of the pipeline.  There are notable 
exceptions obviously.  But this is still a scalability problem in 
itself.  So we need men-in-the-middle attacks.

> I've told people this before, and I'll tell it again: when I flame
> submaintainers, they should try to push the pain down. I'm not really
> asking those submaintainers to clean up all the stuff they are
> getting: I'm basically asking people to say "no", or at least push
> back a lot, and argue with the people who send you code. Tell them
> what you don't like about the code, and tell them that you can't take
> it any more.

I wish we could be sufficient people to be able to determine what we 
actually don't like about the code.  There is simply not enough core 
kernel people with the required visibility doing such work in ARM land.  
That's the fundamental problem.  The fact that the most successful 
"real" ARM devices running Linux out there still aren't supported in 
mainline doesn't help building a community of enthusiasts around it 
either.

> > And we can't count on vendor people doing this work.  They are all busy
> > porting the kernel to their next SOC version so they can win the next
> > big Android hardware design, and doing so with our kernel quality
> > standards is already quite a struggle for them.
> 
> This really isn't the argument. The argument should be that if they
> want their code up-stream, they need to do a good job. If they don't,
> why should you take it at all?

Embedded vendors did keep their code out of the kernel before.  We've 
been hammering them about upstreaming their code for years.  Now they 
are striking back with too much code for our review capacity.  So 
problematic code gets merged without anyone noticing because it compiles 
and does work, until someone comes along with a wide scale API cleanup 
and stumble on it.

The alternative is to only accept fully reviewed code, but to scale with 
the numbers we've all seen, 60% of the reviewers should be looking at 
ARM code and that's not happening.  We've been there before, like two 
years ago or so. Pressure builds up at the maintainer gate as the 
backlog grows and key people get burned out, then the system collapses.  
No one wants to go back there.

> > What is going on at the moment is some effort to introduce DT support to
> > ARM.  The core support is there, but that is useless until platform code
> > is moved to it, and corresponding work is put into bootloaders, etc.
> > That is progressing... slowly.
> 
> How about not moving platform code TO it, but at least saying that you
> won't accept new platform code that doesn't use it? When somebody
> sends you a new platform, just say "no" if it's another copy-paste job
> or another "add yet another #ifdef or conditional to a messy driver".

DT has to prove itself on ARM with a few existing platforms before we 
can open the flood gate towards it.  If something is wrong with DT 
support it is best to fix only the core stuff without also having to fix 
all users and possibly all bootloaders, etc.  That work is progressing 
slowly because there are more people praising DT than people doing the 
actual work.


Nicolas

--Boundary_(ID_AINh8tpyRSxXIxb+njnndA)--

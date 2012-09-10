Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab2IJXbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:31:18 -0400
Received: from relais.videotron.ca ([24.201.245.36]:13612 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2IJXbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:31:16 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Mon, 10 Sep 2012 19:31:14 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arch@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 31/31] arm64: MAINTAINERS update
In-reply-to: <20120910211757.GD31998@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.02.1209101834530.28681@xanadu.home>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-32-git-send-email-catalin.marinas@arm.com>
 <20120909163156.GA31430@game.jcrosoft.org>
 <alpine.LFD.2.02.1209101355000.28681@xanadu.home>
 <20120910211757.GD31998@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2012, Russell King - ARM Linux wrote:

> On Mon, Sep 10, 2012 at 01:57:57PM -0400, Nicolas Pitre wrote:
> > On Sun, 9 Sep 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > 
> > > On 17:27 Fri 07 Sep     , Catalin Marinas wrote:
> > > > This patch updates the MAINTAINERS file for the AArch64 Linux kernel
> > > > port.
> > > > 
> > > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > Acked-by: Tony Lindgren <tony@atomide.com>
> > > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > > ---
> > > >  MAINTAINERS |    6 ++++++
> > > >  1 files changed, 6 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index fdc0119..de368a5 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -1209,6 +1209,12 @@ S:	Maintained
> > > >  F:	arch/arm/mach-pxa/z2.c
> > > >  F:	arch/arm/mach-pxa/include/mach/z2.h
> > > >  
> > > > +ARM64 PORT (AARCH64 ARCHITECTURE)
> > > > +M:	Catalin Marinas <catalin.marinas@arm.com>
> > > we should put Russell too
> > 
> > He is not maintaining the ARM64 code.
> 
> And, let's say the rest of it - it doesn't take much inteligence to work
> out what that means for me personally.

For the record, let me state out loud what I think.

I truly think that the core ARM code is a nice piece of art, and this is 
because of your technical excellence and good taste with code.  The ARM 
ecosystem is wide and varied, and keeping it from morphing into a horrid 
mess is a thankless challenge.  We as a community certainly don't say 
this very often if at all, but we certainly owe you a big "thank you" 
for the excellent work you did so far, and I hope you'll go on with it 
for quite some time yet. In any case, no one with excellent coding 
skills such as yours is ever going to lack work and opportunities in 
this community.

Even x86, despite its long history in the Linux kernel, is less 
fragmented and diversified than the ARM architecture.  For better or 
worse, the ARM Ltd business model is different from Intel's.  That might 
be good for the ARM market share and vendor differentiation, but this is 
far from the ideal scenario for kernel developers.  I said it in the 
past and I'll say it again: X86 is peanuts in comparison.

Yet, X86 has 3 listed maintainers according to the MAINTAINERS file.  
ARM has only one.  AS far as I can see, no one is crazy enough to be 
maintainer for two or more architectures.

Unless you were to give up on the ARM 32 bit maintenance, I don't see 
how you could be able to maintain both ARM and ARM64 at the same time 
without losing your sanity or sacrificing on the quality of the code you 
contribute. .  Fortunately, Catalin is willing to maintain the ARM64 
port and he appears pretty motivated as well.  Unless he does screw up, 
we should let him bear this weight.


Nicolas

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1DARpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 13:45:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52793 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1DARpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 13:45:49 -0400
Date: Fri, 1 Apr 2011 18:44:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Detlef Vollmann <dv@vollmann.ch>, Ingo Molnar <mingo@elte.hu>,
        david@lang.hm, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110401174459.GA8615@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <201104011659.40443.arnd@arndb.de> <4D95EF8E.9080902@vollmann.ch> <201104011750.17344.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104011750.17344.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 05:50:17PM +0200, Arnd Bergmann wrote:
> On Friday 01 April 2011, Detlef Vollmann wrote:
> > On 04/01/11 16:59, Arnd Bergmann wrote:
> > > On Friday 01 April 2011, Detlef Vollmann wrote:
> > >> On 04/01/11 15:54, Arnd Bergmann wrote:
> > >
> > >>> 9. All interesting work is going into a handful of platforms, all of which
> > >>>      are ARMv7 based.
> > >> Define interesting.
> > >
> > > The ones that are causing the churn that we're talking about.
> > > Platforms that have been working forever and only need to get
> > > the occasional bug fix are boring, i.e. not the problem.
> > In the ARM tree I only know mach-at91.
> > Atmel still introduces new SOCs based on ARM926EJ-S, and that makes
> > perfect sense for lots of applications.
> 
> I thought new ones were generally Cortex-M3 based. Either way, even
> if there are exceptions, focusing on ARMv7 at first should give
> a good representation of the new development.

If they're M3 then they're a microcontroller, and so would be using uclinux.

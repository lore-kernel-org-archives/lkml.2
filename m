Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1EZIeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:34:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:51518 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1EZIeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:34:02 -0400
Date: Thu, 26 May 2011 10:33:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] ARM Subarchitecture group maintainership
In-Reply-To: <20110526082807.GA11783@sirena.org.uk>
Message-ID: <alpine.LFD.2.02.1105261030560.3078@ionos>
References: <201105181047.17309.arnd@arndb.de> <BANLkTi=xzrLhHTBynWf4huA9EusfaDwPbA@mail.gmail.com> <20110525075902.GH30799@atomide.com> <alpine.LFD.2.00.1105251021550.3207@xanadu.home> <20110525153459.GE27250@atomide.com> <alpine.LFD.2.02.1105251803120.3078@ionos>
 <20110526082807.GA11783@sirena.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Mark Brown wrote:

> On Wed, May 25, 2011 at 06:06:16PM +0200, Thomas Gleixner wrote:
> > On Wed, 25 May 2011, Tony Lindgren wrote:
> 
> > > What do you want to do with with the various for-next branches?
> 
> > > Do you want to queue things into your tree before hitting for-next?
> 
> > The stuff which gets pulled in from the various suppliers is
> > aggregated in a separate for -next branch.
> 
> I think the question is about the existing -next branches people already
> have - should they contain code that hasn't yet gone to you guys?  We're
> doing that for audio at the minute (having subtrees in -next directly)
> and it's pretty helpful for miniising hassle for the maintainers of the
> core tree.

We obviously talk about arch/arm/[mach|plat]* stuff, drivers/ sound/
etc. should go through the relevant maintainer trees.

Thanks,

	tglx


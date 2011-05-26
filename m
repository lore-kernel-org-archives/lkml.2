Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab1EZKEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:04:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45440 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751145Ab1EZKEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:04:52 -0400
Date: Thu, 26 May 2011 10:59:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] ARM Subarchitecture group maintainership
Message-ID: <20110526095919.GA31268@opensource.wolfsonmicro.com>
References: <201105181047.17309.arnd@arndb.de> <BANLkTi=xzrLhHTBynWf4huA9EusfaDwPbA@mail.gmail.com> <20110525075902.GH30799@atomide.com> <alpine.LFD.2.00.1105251021550.3207@xanadu.home> <20110525153459.GE27250@atomide.com> <alpine.LFD.2.02.1105251803120.3078@ionos> <20110526082807.GA11783@sirena.org.uk> <alpine.LFD.2.02.1105261030560.3078@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105261030560.3078@ionos>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 10:33:55AM +0200, Thomas Gleixner wrote:
> On Thu, 26 May 2011, Mark Brown wrote:

> > I think the question is about the existing -next branches people already
> > have - should they contain code that hasn't yet gone to you guys?  We're
> > doing that for audio at the minute (having subtrees in -next directly)
> > and it's pretty helpful for miniising hassle for the maintainers of the
> > core tree.

> We obviously talk about arch/arm/[mach|plat]* stuff, drivers/ sound/
> etc. should go through the relevant maintainer trees.

Right, but the question is what to do with the subtrees that are in
-next currently.  I'm mentioning sound as an example of a tree with
subtrees in -next directly.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1EZI2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:28:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56486 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1EZI2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:28:16 -0400
Date: Thu, 26 May 2011 09:28:07 +0100
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
Message-ID: <20110526082807.GA11783@sirena.org.uk>
References: <201105181047.17309.arnd@arndb.de> <BANLkTi=xzrLhHTBynWf4huA9EusfaDwPbA@mail.gmail.com> <20110525075902.GH30799@atomide.com> <alpine.LFD.2.00.1105251021550.3207@xanadu.home> <20110525153459.GE27250@atomide.com> <alpine.LFD.2.02.1105251803120.3078@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105251803120.3078@ionos>
X-Cookie: Youth is the trustee of posterity.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 06:06:16PM +0200, Thomas Gleixner wrote:
> On Wed, 25 May 2011, Tony Lindgren wrote:

> > What do you want to do with with the various for-next branches?

> > Do you want to queue things into your tree before hitting for-next?

> The stuff which gets pulled in from the various suppliers is
> aggregated in a separate for -next branch.

I think the question is about the existing -next branches people already
have - should they contain code that hasn't yet gone to you guys?  We're
doing that for audio at the minute (having subtrees in -next directly)
and it's pretty helpful for miniising hassle for the maintainers of the
core tree.

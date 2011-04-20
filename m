Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1DTNOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:14:46 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41431 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754264Ab1DTNOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:14:45 -0400
Date: Wed, 20 Apr 2011 15:14:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>, stable@kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 intel power: Initialize MSR_IA32_ENERGY_PERF_BIAS
Message-ID: <20110420131442.GA29418@atrey.karlin.mff.cuni.cz>
References: <alpine.LFD.2.02.1103301819250.31342@x980> <20110414090854.GB9248@elte.hu> <alpine.LFD.2.02.1104150202310.29365@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1104150202310.29365@x980>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > However, the typical BIOS fails to initialize the MSR,
> > > and the typical Linux distro neglects to invoke x86_energy_perf_policy(8).
> > > 
> > > The result is that some modern hardware is running in hardware default,
> > > which is "performance" mode, rather than the intended design default
> > > of "normal" mode.
> > > 
> > > Initialize the MSR to the "normal" setting during kernel boot.
> > > 
> > > Of course, x86_energy_perf_policy(8) is available to change
> > > the default after boot, should the user have a policy preference.
> > > 
> > > cc: stable@kernel.org
...
> Will it be possible to measure a performance difference between
> "performance" and "normal"?  Yes, it will be possible.

Ok. So... what "serious bug" does this fix? You really need to use cc:
stable less. Tweaking performance/power ratio is _not_ serious bug.


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

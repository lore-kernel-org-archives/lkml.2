Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab1EYO2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:28:44 -0400
Received: from relais.videotron.ca ([24.201.245.36]:38759 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1EYO2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:28:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 25 May 2011 10:28:41 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Tony Lindgren <tony@atomide.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
In-reply-to: <20110525075902.GH30799@atomide.com>
Message-id: <alpine.LFD.2.00.1105251021550.3207@xanadu.home>
References: <201105181047.17309.arnd@arndb.de>
 <BANLkTi=xzrLhHTBynWf4huA9EusfaDwPbA@mail.gmail.com>
 <20110525075902.GH30799@atomide.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Tony Lindgren wrote:

> * Catalin Marinas <catalin.marinas@arm.com> [110518 17:49]:
> > Arnd,
> > 
> > On 18 May 2011 09:47, Arnd Bergmann <arnd@arndb.de> wrote:
> > > This is the draft plan for maintaining the ARM subarchitectures in a common
> > > tree, as a way to help coordinate the upstream merging of the
> > > arch/arm/{plat,mach}-* changes into Linus' tree.
> > 
> > For clarification - the aim of this subarchitecture group is not only
> > to coordinate the upstream merging but also take an active (primary)
> > role in consolidating the existing code across various
> > subarchitectures under arch/arm/.
> 
> It's good to see organized effort on consolidating the code.
> And Linaro is probably the best place to organize this effort.
> 
> Naturally I assume that you guys won't be merging any platform
> specific patches without proper acks from the platform maintainers:

Obviously.  In fact I expect platform maintainers to be the ones pushing 
their merge requests to us.  This is not going to replace the job you're 
currently doing.

> Arnd, do you want to do a practise run with pulling in the omap
> code and merging to Linus for this merge window?

No.  We'll start merging stuff once this merge window is over.  In other 
words, you are still on your own for the current one.

Also, I want stuff merged in this subarch tree way before the next merge 
window opens on a continuous basis, not in a big rush before it opens, 
or worse, while it is already open.


Nicolas




> 
> Regards,
> 
> Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

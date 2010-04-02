Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0DBMh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 08:37:28 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:59178 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752811Ab0DBMhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 08:37:21 -0400
Date: Fri, 2 Apr 2010 11:31:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Linus Torvalds <torvalds@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [patch 1/2] genirq: Run irq handlers with interrupts disabled
Message-ID: <20100402093132.GA1360@ucw.cz>
References: <20100326000325.917127328@linutronix.de> <20100326000405.758579387@linutronix.de> <20100326061310.GV20695@one.firstfloor.org> <alpine.LFD.2.00.1003261224070.3147@localhost.localdomain> <20100330053325.GL20695@one.firstfloor.org> <alpine.LFD.2.00.1003311315520.32352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003311315520.32352@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-03-31 13:16:37, Thomas Gleixner wrote:
> On Tue, 30 Mar 2010, Andi Kleen wrote:
> 
> > > Why not simply force IRQF_DISABLED for all MSI interrupts. That still
> > > allows nesting for non MSI ones, but it limits the chance of throwing
> > > up reasonably well. That's a two liner.
> > > 
> > > Can you please test whether it resolves the issue at hand ?
> > 
> > Sorry for the late answer. Got confirmation that this patch
> > fixes the test case. Thanks.
> 
> Ok, I'll push it linus wards and cc stable. I think thats the least
> intrusive safe bet we can have right now.

stable? I'd say thats way too intrusive for -stable...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

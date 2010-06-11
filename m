Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab0FKPBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 11:01:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50602 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0FKPBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 11:01:53 -0400
Date: Fri, 11 Jun 2010 16:01:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@suse.de>,
       David Brownell <david-b@pacbell.net>, tytso@mit.edu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Neil Brown <neilb@suse.de>,
       Brian Swetland <swetland@google.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] suspend blockers & Android integration
Message-ID: <20100611150124.GG12436@sirena.org.uk>
References: <1276266502.2862.74.camel@mulgrave.site> <Pine.LNX.4.44L0.1006111045340.12006-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1006111045340.12006-100000@netrider.rowland.org>
X-Cookie: Postage will be paid by addressee.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 10:46:27AM -0400, Alan Stern wrote:
> On Fri, 11 Jun 2010, James Bottomley wrote:

> > The one thing that does look difficult is that these power constraints
> > are device (and sometimes SoC) specific.  Expressing them in a generic
> > way for the cpu govenors to make sense of might be hard.

> Doesn't the clock framework already handle this sort of thing?

The clock framework is implemented independantly for each CPU.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0FLRKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 13:10:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50472 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab0FLRKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 13:10:41 -0400
Date: Sat, 12 Jun 2010 18:10:13 +0100
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
Message-ID: <20100612171013.GA3151@sirena.org.uk>
References: <1276268539.2862.92.camel@mulgrave.site>
 <Pine.LNX.4.44L0.1006111638040.19894-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1006111638040.19894-100000@netrider.rowland.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.240.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [linux-pm] suspend blockers & Android integration
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 04:48:15PM -0400, Alan Stern wrote:
> On Fri, 11 Jun 2010, Mark Brown wrote:

> > The clock framework is implemented independantly for each CPU.

> That's not an impediment, since drivers' requirements regarding which 
> clocks remain running in which power states are necessarily 
> platform-dependent also.

It does mean that you can't make any general statements about what the
clock framework does and doesn't do which is what the person I was
replying to (the quoting you did as you cut'n'pasted replies to multiple
messages seems more than a little confused, sorry) seemed to want.

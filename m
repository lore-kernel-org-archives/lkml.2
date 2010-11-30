Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab0K3TWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:22:11 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51502 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755844Ab0K3TWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:22:09 -0500
Date: Tue, 30 Nov 2010 20:21:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcus Meissner <meissner@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de, mingo@elte.hu,
        akpm@linux-foundation.org, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/time: Make /proc/timer_list mode 0400
Message-ID: <20101130192152.GD5295@ucw.cz>
References: <20101117170822.GW20727@suse.de>
 <1290014312.2109.1065.camel@laptop>
 <20101117172111.GX20727@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117172111.GX20727@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > /proc/timer_list contains kernel addresses, like e.g.:
> > >  #0: <c000000001404158>, tick_sched_timer, S:01, .tick_nohz_restart_sched_tick, swapper/0
> > >  ...
> > > 
> > > Avoid leaking them to user space to make writing kernel exploits a bit harder.
> > > 
> > > (I currently cannot think of a userland tool that uses this, this is
> > > likely pretty much root-only.)
> > 
> > iirc powertop parses this..
> 
> powertop already says on startup:
> 
> 	PowerTOP needs to be run as root to collect enough information
> 
> And as developer tool it usually is for people having root access.

.....and now you are actively decreasing security.

Yes, developers usally have root access, but no, developers do not
like to work as root.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2GMWVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 18:21:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:46739 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2GMWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 18:21:52 -0400
Date: Sat, 14 Jul 2012 00:21:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT pull] leap second fixes for 3.5
In-Reply-To: <alpine.LFD.2.02.1207132132120.32033@ionos>
Message-ID: <alpine.LFD.2.02.1207140017080.32033@ionos>
References: <alpine.LFD.2.02.1207132132120.32033@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Thomas Gleixner wrote:

> Linus,
> 
> please pull the latest timers-urgent-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus
> 
> It's a rather large series, but well discussed, refined and
> reviewed. It got a massive testing by John, Prarit and tip.
> 
> In theory we could split it into two parts. The first two patches
> 
>   5baefd6: hrtimer: Update hrtimer base offsets each hrtimer_interrupt
>   f6c06ab: timekeeping: Provide hrtimer update function
> 
> are merily preventing the stuff loops forever issues, which people
> have observed.

I'm a moron. Copied from teh wrong direction. That should be:

  f55a6fa: hrtimer: Provide clock_was_set_delayed()
  4873fa0: timekeeping: Fix leapsecond triggered load spike issue

That are the two commits which do the basic damage containment.

Gah, I explicitely asked some involved person to look over that mail
before I sent it. :(
 
Grumbling out of a brown paperbag

	  tglx

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab1HNEX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 00:23:56 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33474 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750727Ab1HNEXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 00:23:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18VZnV5LVgVXis0rWvOBtG//FlTJ4AwayipZO3cXq
	NZAQKl8e91/RNn
Subject: Re: [ANNOUNCE] 3.0.1-rt11
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <20110813162735.GA2650@linux.vnet.ibm.com>
References: <1313232790.25267.7.camel@twins>
	 <1313236135.4486.10.camel@marge.simson.net>
	 <1313236713.25267.10.camel@twins>
	 <1313243965.4486.36.camel@marge.simson.net>
	 <20110813162735.GA2650@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Aug 2011 06:23:41 +0200
Message-ID: <1313295821.6334.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-13 at 09:27 -0700, Paul E. McKenney wrote:

> Strange.  By the time it got around to printing the stall, no one was
> stalling:
> 
> [  100.409012] INFO: rcu_preempt_state detected stalls on CPUs/tasks: {} (detected by 21, t=60002 jiffies)
> 
> Now it -is- possible for the stall to end just as we get ready to detect
> it, but that window is really really small.  The most recent occurrence
> of this sort of thing was due misconfigured timekeeping, but I don't see
> any sign of that in the trace.
> 
> This happens repeatedly?

Yeah.  When I put -rt9 on the UV box, it was doing the just idling, and
boom thing I saw with earlier releases on both my Q6600 and x3550 M3
boxes.  -rt10 seems to have just changed the timing.

I'll update the x3550 M3, and see if it still gripes.  UV isn't virgin
source, has to be twiddled a little. (symptom was identical though)

	-Mike


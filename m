Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1EGIUp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 04:20:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38643 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1EGIUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 04:20:42 -0400
Date: Sat, 7 May 2011 10:20:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>
Subject: Re: [RFC] time: xtime_lock is held too long
Message-ID: <20110507082018.GC25065@elte.hu>
References: <1304574244.32152.666.camel@edumazet-laptop>
 <1304576495.2943.40.camel@work-vm>
 <1304604284.3032.78.camel@edumazet-laptop>
 <alpine.LFD.2.02.1105051630390.3005@ionos>
 <1304608095.3032.95.camel@edumazet-laptop>
 <alpine.LFD.2.02.1105051750540.3005@ionos>
 <20110505210118.GI2925@one.firstfloor.org>
 <alpine.LFD.2.02.1105061117220.3005@ionos>
 <20110506102232.GA11036@elte.hu>
 <20110506165359.GE11636@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506165359.GE11636@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > Then precise measurements have to be done on the source of cache misses, the 
> > total cost of the timer interrupt, etc.
> 
> What we did was profiling the remote node cache misses
> using raw offcore events, and the xtime code was high up.
> I cannot share exact numbers for various reasons, but it was
> an improvement on a hard to improve workload.

You could certainly share the profiling commands you typed, so that
others can reproduce and double check your results.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab1GAQod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 12:44:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61948 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab1GAQob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 12:44:31 -0400
Date: Fri, 1 Jul 2011 18:44:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL v2] sched: Make sleep inside atomic detection work on
 !PREEMPT
Message-ID: <20110701164425.GG8508@somewhere>
References: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
 <20110622224844.GA3290@somewhere>
 <20110701123629.GA12605@elte.hu>
 <20110701125644.GD8508@somewhere>
 <20110701125926.GF12605@elte.hu>
 <20110701150517.GA24707@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701150517.GA24707@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 05:05:17PM +0200, Ingo Molnar wrote:
> 
> -tip testing also found that m32r fails to build:
> 
> /home/mingo/tip/kernel/sched.c: In function 'preempt_schedule':
> /home/mingo/tip/kernel/sched.c:4364: error: implicit declaration of function 'add_preempt_count_notrace'
> /home/mingo/tip/kernel/sched.c:4366: error: implicit declaration of function 'sub_preempt_count_notrace'
> 
> due to:
> 
> bdd4e85dc36cdbcfc1608a5b2a17c80a9db8986a is the first bad commit
> commit bdd4e85dc36cdbcfc1608a5b2a17c80a9db8986a
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date:   Wed Jun 8 01:13:27 2011 +0200
> 
>     sched: Isolate preempt counting in its own config option
> 
> Thanks,
> 
> 	Ingo

I have no clue how that did happen.

Can you send me your config?

Thanks.

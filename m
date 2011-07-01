Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab1GAPF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:05:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60520 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab1GAPF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:05:28 -0400
Date: Fri, 1 Jul 2011 17:05:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL v2] sched: Make sleep inside atomic detection work on
 !PREEMPT
Message-ID: <20110701150517.GA24707@elte.hu>
References: <1307712622-11104-1-git-send-email-fweisbec@gmail.com>
 <20110622224844.GA3290@somewhere>
 <20110701123629.GA12605@elte.hu>
 <20110701125644.GD8508@somewhere>
 <20110701125926.GF12605@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701125926.GF12605@elte.hu>
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


-tip testing also found that m32r fails to build:

/home/mingo/tip/kernel/sched.c: In function 'preempt_schedule':
/home/mingo/tip/kernel/sched.c:4364: error: implicit declaration of function 'add_preempt_count_notrace'
/home/mingo/tip/kernel/sched.c:4366: error: implicit declaration of function 'sub_preempt_count_notrace'

due to:

bdd4e85dc36cdbcfc1608a5b2a17c80a9db8986a is the first bad commit
commit bdd4e85dc36cdbcfc1608a5b2a17c80a9db8986a
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Wed Jun 8 01:13:27 2011 +0200

    sched: Isolate preempt counting in its own config option

Thanks,

	Ingo

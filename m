Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab1EZU1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:27:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51507 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757892Ab1EZU1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:27:14 -0400
Date: Thu, 26 May 2011 22:26:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage based
 on semi-formal proof"
Message-ID: <20110526202653.GB2765@elte.hu>
References: <4DDC48E3.1060108@kernel.org>
 <20110525045253.GB2262@linux.vnet.ibm.com>
 <4DDD7F96.3090408@kernel.org>
 <20110525223437.GO2341@linux.vnet.ibm.com>
 <4DDD8775.1000501@kernel.org>
 <20110526011310.GP2341@linux.vnet.ibm.com>
 <20110526013029.GA28103@linux.vnet.ibm.com>
 <20110526061348.GA26775@elte.hu>
 <20110526142553.GA2386@linux.vnet.ibm.com>
 <20110526174301.GA9649@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526174301.GA9649@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > > this should also solve load average artifacts - do not 
> > > TASK_UNINTERRUPTIBLE tasks skew the load upwards?
> > 
> > Quite possibly -- in this case the artifacts would appear just 
> > after boot, and would disappear as soon as the RCU kthreads had 
> > something to do.
> 
> By the way, how would you like to proceed with the fixes thus far? 
> I have put them on -rcu for -next testing, FWIW.

I'd suggest to push them to me ASAP, they should get to Linus before 
-rc1.

Thanks,

	Ingo

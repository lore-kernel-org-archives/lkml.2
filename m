Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab1FWKpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 06:45:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55648 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759157Ab1FWKpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 06:45:09 -0400
Date: Thu, 23 Jun 2011 12:44:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
Message-ID: <20110623104455.GA9274@elte.hu>
References: <20110622174659.496793734@linutronix.de>
 <20110622174919.135236139@linutronix.de>
 <20110623083722.GF30101@htj.dyndns.org>
 <alpine.LFD.2.02.1106231139270.11814@ionos>
 <20110623101541.GL30101@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623101541.GL30101@htj.dyndns.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> The patch description is simply untrue.  It does affect how wq 
> behaves under heavy CPU load.  The effect might be perfectly okay 
> but more likely it will result in subtle suboptimal behaviors under 
> certain load situations which would be difficult to characterize 
> and track down.  Again, the trade off (mostly killing of 
> ttwu_local) could be okay but you can't get away with just claiming 
> "there's no harm".

Well, either it can be measured or not. If you can suggest a specific 
testing method to Thomas, please do.

Thanks,

	Ingo

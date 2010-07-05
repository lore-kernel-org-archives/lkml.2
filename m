Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab0GEROk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 13:14:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab0GEROi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 13:14:38 -0400
Date: Mon, 5 Jul 2010 19:14:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending() (was: Linux 2.6.35-rc4)
Message-ID: <20100705171420.GA29697@elte.hu>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
 <20100705085550.GA26775@elte.hu>
 <20100705164022.GA26995@infradead.org>
 <20100705171125.GB26202@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705171125.GB26202@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0232]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Christoph Hellwig <hch@infradead.org> wrote:
> 
> > We had a thread about it a few days ago.  The following commit from
> > Jens' 2.6.36 tree needs to go into 2.6.35 to sort the issues with the
> > fragile wakeup mechanism which only got worse by the patches out:
> > 	
> > 	http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=79338d2a78ab78efdc1698f1309766a039addf9d
> 
> I've attached it below - in case someone wants to apply it before it hits 
> upstream.
> 
> Scary big patch btw. - is there no smaller fix?

Nor does it apply to v2.6.35-rc4:

 Applying: writeback: simplify the write back thread queue
 error: patch failed: fs/fs-writeback.c:703
 error: fs/fs-writeback.c: patch does not apply
 Patch failed at 0001 writeback: simplify the write back thread queue

I guess it has other dependencies as well. If you want me to test the fix then 
please send a version that applies.

Thanks,

	Ingo

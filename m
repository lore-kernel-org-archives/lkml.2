Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab0GFGuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 02:50:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58787 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab0GFGuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 02:50:09 -0400
Date: Tue, 6 Jul 2010 08:49:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending()
Message-ID: <20100706064946.GA16224@elte.hu>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
 <20100705085550.GA26775@elte.hu>
 <20100705164022.GA26995@infradead.org>
 <20100705171125.GB26202@elte.hu>
 <20100705171420.GA29697@elte.hu>
 <20100705182003.GA12332@infradead.org>
 <4C323177.3070606@kernel.dk>
 <4C324C78.5090805@tmr.com>
 <AANLkTinLrbQNv9uKYZCAKS-kFPSdle3fvAMzjI77BCu2@mail.gmail.com>
 <4C32CC6A.3070004@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C32CC6A.3070004@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0520]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <axboe@kernel.dk> wrote:

> > But I obviously don't actually see the problem, so it would be good to get 
> > confirmation that Christoph's patch actually fixes things first. Ingo, 
> > does the one in this thread apply for you?
> 
> I'll update for-linus, Ingo can try that.

I have cherry-picked the 3 patches explicitly yesterday, and overnight testing 
showed that the bug is fixed. Please send them to Linus.

Thanks,

	Ingo

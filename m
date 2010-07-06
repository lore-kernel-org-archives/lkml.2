Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0GFG45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 02:56:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56536 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab0GFG44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 02:56:56 -0400
Date: Tue, 6 Jul 2010 08:56:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending()
Message-ID: <20100706065636.GB16224@elte.hu>
References: <20100705085550.GA26775@elte.hu>
 <20100705164022.GA26995@infradead.org>
 <20100705171125.GB26202@elte.hu>
 <20100705171420.GA29697@elte.hu>
 <20100705182003.GA12332@infradead.org>
 <4C323177.3070606@kernel.dk>
 <4C324C78.5090805@tmr.com>
 <AANLkTinLrbQNv9uKYZCAKS-kFPSdle3fvAMzjI77BCu2@mail.gmail.com>
 <20100706064733.GA12382@elte.hu>
 <4C32D243.1050806@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C32D243.1050806@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0454]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <axboe@kernel.dk> wrote:

> On 2010-07-06 08:47, Ingo Molnar wrote:
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> >> On Mon, Jul 5, 2010 at 2:19 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> >>>
> >>> Absent a small fix, and given that the big fix has a lot more testing than
> >>> any new patch might, in this case the quickie might be undesirable.
> >>> Particularly since posters here seem sure that code will be replaced in the
> >>> next version anyway, and lightly tested patch to obsolete code is actually
> >>> less conservative.
> >>
> >> I have to agree. Especially as the "big patch" just removes the fragile code 
> >> that caused the problem in the first place. So in this case I do suspect 
> >> that the bigger patch ends up being the safer one.
> > 
> > Yeah, i agree - especially since the smaller patch is still pretty large (not 
> > a oneliner), plus it does not appear that the precise failure mode is fully 
> > understood either.
> 
> http://lkml.org/lkml/2010/7/5/232
> 
> It's about as straight forward as it can be :-)

Yeah, i meant Christoph's first patch. Yours looks simple enough but from the 
discussion it wasnt clear (to me) yet whether it would fix the bug.

Thanks,

	Ingo

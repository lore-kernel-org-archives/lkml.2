Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab0GEXfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 19:35:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754951Ab0GEXfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 19:35:01 -0400
MIME-Version: 1.0
In-Reply-To: <4C324C78.5090805@tmr.com>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
	<20100705085550.GA26775@elte.hu>
	<20100705164022.GA26995@infradead.org>
	<20100705171125.GB26202@elte.hu>
	<20100705171420.GA29697@elte.hu>
	<20100705182003.GA12332@infradead.org>
	<4C323177.3070606@kernel.dk>
	<4C324C78.5090805@tmr.com>
Date: Mon, 5 Jul 2010 16:34:42 -0700
Message-ID: <AANLkTinLrbQNv9uKYZCAKS-kFPSdle3fvAMzjI77BCu2@mail.gmail.com>
Subject: Re: [regression] Crash in wb_clear_pending()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 5, 2010 at 2:19 PM, Bill Davidsen <davidsen@tmr.com> wrote:
>
> Absent a small fix, and given that the big fix has a lot more testing than
> any new patch might, in this case the quickie might be undesirable.
> Particularly since posters here seem sure that code will be replaced in the
> next version anyway, and lightly tested patch to obsolete code is actually
> less conservative.

I have to agree. Especially as the "big patch" just removes the
fragile code that caused the problem in the first place. So in this
case I do suspect that the bigger patch ends up being the safer one.

But I obviously don't actually see the problem, so it would be good to
get confirmation that Christoph's patch actually fixes things first.
Ingo, does the one in this thread apply for you?

               Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0GFGZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 02:25:51 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33037 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab0GFGZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 02:25:50 -0400
Message-ID: <4C32CC6A.3070004@kernel.dk>
Date: Tue, 06 Jul 2010 08:25:46 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bill Davidsen <davidsen@tmr.com>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending()
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>	<20100705085550.GA26775@elte.hu>	<20100705164022.GA26995@infradead.org>	<20100705171125.GB26202@elte.hu>	<20100705171420.GA29697@elte.hu>	<20100705182003.GA12332@infradead.org>	<4C323177.3070606@kernel.dk>	<4C324C78.5090805@tmr.com> <AANLkTinLrbQNv9uKYZCAKS-kFPSdle3fvAMzjI77BCu2@mail.gmail.com>
In-Reply-To: <AANLkTinLrbQNv9uKYZCAKS-kFPSdle3fvAMzjI77BCu2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-06 01:34, Linus Torvalds wrote:
> On Mon, Jul 5, 2010 at 2:19 PM, Bill Davidsen <davidsen@tmr.com> wrote:
>>
>> Absent a small fix, and given that the big fix has a lot more testing than
>> any new patch might, in this case the quickie might be undesirable.
>> Particularly since posters here seem sure that code will be replaced in the
>> next version anyway, and lightly tested patch to obsolete code is actually
>> less conservative.
> 
> I have to agree. Especially as the "big patch" just removes the
> fragile code that caused the problem in the first place. So in this
> case I do suspect that the bigger patch ends up being the safer one.

OK, it's up to you.

> But I obviously don't actually see the problem, so it would be good to
> get confirmation that Christoph's patch actually fixes things first.
> Ingo, does the one in this thread apply for you?

I'll update for-linus, Ingo can try that.

-- 
Jens Axboe


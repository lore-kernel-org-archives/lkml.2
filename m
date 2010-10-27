Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469Ab0J0ITM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:19:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38918 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389Ab0J0ITK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:19:10 -0400
Date: Wed, 27 Oct 2010 10:18:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, n-horiguchi@ah.jp.nec.com, x86@kernel.org
Subject: Re: [GIT PULL] Please pull hwpoison updates for 2.6.37
Message-ID: <20101027081853.GA20196@elte.hu>
References: <20101026100923.GA5118@basil.fritz.box>
 <20101027074254.GA809@elte.hu>
 <20101027075846.GA2472@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027075846.GA2472@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
>
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> >
> > > [...]
> > >
> > > - x86 hwpoison signal reporting fix. I tried to get an ack for that,
> > >   but wasn't able to motivate the x86 maintainers to reply to their emails.
> > 
> > Hm, you sent it once two weeks before the merge window and we missed that.
> > 
> > Patch looks ok. (I'd personally not expose an #ifdef in the middle of a function 
> > like that but that's a detail that doesnt affect correctness.)
> > 
> > Thanks,
> 
> Thanks for the review.

You are welcome! How about the cleanliness feedback that i gave?
(the stuff in parentheses)

Thanks,

	Ingo

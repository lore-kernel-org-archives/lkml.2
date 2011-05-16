Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab1EPLQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:16:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35755 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab1EPLQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:16:30 -0400
Date: Mon, 16 May 2011 13:16:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stephan.baerwolf@tu-ilmenau.de, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Fix and optimise calculation of the
 weight-inverse
Message-ID: <20110516111610.GD19837@elte.hu>
References: <tip-0pz0wnyalr4tk4ln11xwumdx@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-0pz0wnyalr4tk4ln11xwumdx@git.kernel.org>
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


* tip-bot for Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de> wrote:

> Commit-ID:  db670dac49b5423b39b5e523d28fe32045d71b10
> Gitweb:     http://git.kernel.org/tip/db670dac49b5423b39b5e523d28fe32045d71b10
> Author:     Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
> AuthorDate: Wed, 11 May 2011 18:03:29 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 16 May 2011 11:01:18 +0200

Just want to highlight this aspect of Stephan's scheduler fix for the lkml 
discussion:

> [ This could explain some aritmetical issues for small shares but nothing
>   concrete has been reported yet so we are not confident enough to queue
>   this up in sched/urgent and for -stable backport. But if anyone finds
>   this commit and sees it to fix some badness then we can certainly
>   change our mind! ]
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

So this could be a -stable candidate because it's a fix and it's simple, except 
that at the moment we have no reason to believe that this is a regression or a 
serious bug.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab0ERQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:09:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38442 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab0ERQJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:09:25 -0400
Date: Tue, 18 May 2010 18:09:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, v2] core/locking changes for v2.6.35
Message-ID: <20100518160915.GA21239@elte.hu>
References: <20100517212848.GA28536@elte.hu>
 <alpine.LFD.2.00.1005180729340.4195@i5.linux-foundation.org>
 <20100518145212.GA21448@elte.hu>
 <alpine.LFD.2.00.1005180815460.4195@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005180815460.4195@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0060]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 18 May 2010, Ingo Molnar wrote:
> > 
> > But we can also chop off the final commit and redo it 
> > without the jiffies timeout.
> 
> Ok. I pulled your top-commit-missing version instead. Thanks,

Thanks! Will handle the BKL/spin-mutex bug fix separately.

	Ingo

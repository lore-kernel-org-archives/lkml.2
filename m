Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab2CMIsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:48:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47877 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207Ab2CMIsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:48:12 -0400
Date: Tue, 13 Mar 2012 09:48:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: linux-next: manual merge of the arm tree with Linus' tree
Message-ID: <20120313084803.GA6991@elte.hu>
References: <20120313110840.7b444deb6b1bb902c15f3cdf@canb.auug.org.au>
 <20120313061622.GA24357@elte.hu>
 <20120313083310.GA27560@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313083310.GA27560@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Russell King <rmk@arm.linux.org.uk> wrote:

> Please check your mailbox:
> 
> Date: Fri, 20 Jan 2012 17:42:27 +0000
> From: Catalin Marinas <catalin.marinas@arm.com>
> To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
> Cc: Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
>         Peter Zijlstra <peterz@infradead.org>,
>         Will Deacon <will.deacon@arm.com>,
>         Frank Rowand <frank.rowand@am.sony.com>
> Subject: [PATCH v3 1/6] sched: Introduce the finish_arch_post_lock_switch()
>         scheduler hook

Btw., are you losing emails? Because the reply from peterz to 
those patches, a month ago, was pretty clear:

> > Russell, what's the status of these patches? I'd like to see 
> > them land in 3.4 if possible. I'm fine either way, I'll
> >
> > probably ask Ingo to pull your tree so that I can stack some 
> > other patches on top.

You never replied to PeterZ's request, you just ignored this 
scheduler maintainer request and you just did it in some random 
way that was most convenient to you many weeks after the thread 
died down, ignoring everyone else's concerns - a pretty usual 
pattern from you I have to say.

Had you followed PeterZ's request this conflict in linux-next 
could have been avoided, amongst other things.

Given that the merge window is close I doubt there will be 
other, more difficult to resolve conflicts, but this incident 
again demonstrates your inability to communicate efficiently and 
amicably, forcing me to highlight it in this trivial case 
because it's a sadly reoccuring pattern.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1BHPQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:16:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50460 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab1BHPQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:16:05 -0500
Date: Tue, 8 Feb 2011 16:15:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, tglx <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lockdep: possible reason: unannotated irqs-off. (was: Re: Linux
 2.6.38-rc4)
Message-ID: <20110208151551.GB20357@elte.hu>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <20110208101730.GB7020@liondog.tnic>
 <1297161712.13327.100.camel@laptop>
 <20110208121108.GA4824@zhy>
 <20110208133457.GA5813@zhy>
 <1297172906.13327.104.camel@laptop>
 <1297174680.13327.107.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297174680.13327.107.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2011-02-08 at 14:48 +0100, Peter Zijlstra wrote:
> > 
> > Well that and modifying softirq bits for a lockdep annotation really
> > feels wrong. 
> 
> How about we revert it for this release and try again later?

That's the sanest way forward i think ...

I've queued up the revert.

Thanks,

	Ingo

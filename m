Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1CTMiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 08:38:46 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59451 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab1CTMin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 08:38:43 -0400
Date: Sun, 20 Mar 2011 13:38:37 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
In-Reply-To: <20110320105412.GA11266@elte.hu>
Message-ID: <Pine.LNX.4.64.1103201336530.28495@ask.diku.dk>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
 <20110317211548.646b04d2@tpl.lwn.net> <1300419170.16880.956.camel@gandalf.stny.rr.com>
 <AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
 <AANLkTi=2d8S_Pi8kuZMXAmNvHa_2KrOs6K+_FF6P7-pU@mail.gmail.com>
 <Pine.LNX.4.64.1103200852080.28495@ask.diku.dk>
 <AANLkTi=MMKvA-9pFiM1K_JSXjS71JLRCem8THnhu-0=N@mail.gmail.com>
 <Pine.LNX.4.64.1103201007430.28495@ask.diku.dk> <20110320105412.GA11266@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > [...] and also that it would too much complicate our development process.
> 
> 'our' as in the Linux kernel development process? I really don't think it's an 
> issue - see above.
> 
> or 'our' as in Coccinelle development process? When we brought tools/perf/ into 
> the kernel repo all it forced on us were sane Git commits and a predictable, 
> (modulo-) 3 months release/stabilization cycle. Both constraints served the 
> quality of the perf project very well - but of course your milage may vary.

Yes, I meant the Coccinelle development process.

> > One reason for using multiple machines would be to work on multiple 
> > architectures.  But Coccinelle is not sensitive to the architecture on 
> > which it is run, so perhaps you do't need to have it installed everywhere.
> 
> I think the point Pekka tried to make is to have it integrated into the kbuild 
> mechanism as well at a certain point. That way it's very easy to use it and we 
> maintainers could require frequent patch submitters to use those tools to check 
> the quality of their patches. Right now i cannot require that, as it's not part 
> of the kernel repo. Requiring a checkpatch.pl check is much easier, as it's 
> available to everyone who is writing kernel patches.

There remains the problem that if it is just the sources that are part of 
the kernel, the user has to have the ocaml compiler installed.

julia

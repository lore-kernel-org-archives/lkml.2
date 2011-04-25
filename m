Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab1DYT4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 15:56:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43524 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758152Ab1DYT4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 15:56:34 -0400
Date: Mon, 25 Apr 2011 21:55:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arun@sharma-home.net,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110425195554.GB391@elte.hu>
References: <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110422203222.GA21219@elte.hu>
 <20110423000347.GC9328@tassilo.jf.intel.com>
 <1303545012.2298.44.camel@twins>
 <BANLkTi=pk7J1uqCQvJe+RrTPoi=K1Aa5QQ@mail.gmail.com>
 <1303564561.2298.62.camel@twins>
 <20110425194002.GA30576@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425194002.GA30576@tassilo.jf.intel.com>
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


* Andi Kleen <ak@linux.intel.com> wrote:

> One example of this we had recently in the kernel: 
> 
> function accesses three global objects. Scalability tanks when the test is 
> run with more CPUs.  Now the hit is near the three memory accesses. Which one
> is the one that is actually bouncing cache lines?

that's not an example - you are still only giving vague, untestable, 
unverifiable references. You need to give us something specific and 
reproducible - preferably a testcase.

Peter and me are doing lots of scalability work in the core kernel and for most 
problems i've met it was enough if we knew the function name - the scalability 
problem is typically very obvious from that point on - and an annotated profile 
makes it even more obvious.

I've never met a situation what you describe, that it was not possible to 
disambiguate a real SMP bounce - and i've been fixing SMP bounces in the kernel 
for over ten years.

So you really will have to back up your point with an accurate, reproducible 
testcase - vague statements like the ones you are making i do not accept at 
face value, sorry.

Thanks,

	Ingo

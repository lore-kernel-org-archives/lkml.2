Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab1DVUcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 16:32:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51239 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418Ab1DVUcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 16:32:42 -0400
Date: Fri, 22 Apr 2011 22:32:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: arun@sharma-home.net
Cc: Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110422203222.GA21219@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422203022.GA20573@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * arun@sharma-home.net <arun@sharma-home.net> wrote:
> 
> > On Fri, Apr 22, 2011 at 12:52:11PM +0200, Ingo Molnar wrote:
> > > 
> > > Using the generalized cache events i can run:
> > > 
> > >  $ perf stat --repeat 10 -e cycles:u -e instructions:u -e l1-dcache-loads:u -e l1-dcache-load-misses:u ./array
> > > 
> > >  Performance counter stats for './array' (10 runs):
> > > 
> > >          6,719,130 cycles:u                   ( +-   0.662% )
> > >          5,084,792 instructions:u           #      0.757 IPC     ( +-   0.000% )
> > >          1,037,032 l1-dcache-loads:u          ( +-   0.009% )
> > >          1,003,604 l1-dcache-load-misses:u    ( +-   0.003% )
> > > 
> > >         0.003802098  seconds time elapsed   ( +-  13.395% )
> > > 
> > > I consider that this is 'bad', because for almost every dcache-load there's a 
> > > dcache-miss - a 99% L1 cache miss rate!
> > 
> > One could argue that all you need is cycles and instructions. [...]
> 
> Yes, and note that with instructions events we even have skid-less PEBS 
> profiling so seeing the precise .
                                  - location of instructions is possible.

[ An email gremlin ate that part of the sentence. ]

Thanks,

	Ingo

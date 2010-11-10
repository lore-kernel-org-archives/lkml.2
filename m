Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0KJSwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:52:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37326 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527Ab0KJSwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:52:40 -0500
Date: Wed, 10 Nov 2010 19:52:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        mchehab@redhat.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC/Requirements/Design] h/w error reporting
Message-ID: <20101110185213.GJ22410@elte.hu>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
 <20101110101450.GA18481@elte.hu>
 <1289400056.12418.139.camel@gandalf.stny.rr.com>
 <1289400234.2191.129.camel@laptop>
 <1289401781.12418.145.camel@gandalf.stny.rr.com>
 <1289403019.2084.17.camel@laptop>
 <1289407960.12418.169.camel@gandalf.stny.rr.com>
 <20101110170559.GA15704@a1.tnic>
 <20101110174122.GA4001@elte.hu>
 <1289412587.12418.179.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289412587.12418.179.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2010-11-10 at 18:41 +0100, Ingo Molnar wrote:
> 
> > > It would also be cool to be able to allocate those buffers as early as possible, 
> > > even if before MCA is enabled, so that I won't have to copy MCE data which got 
> > > logged before the tracing subsystem got enabled to the buffers proper.
> > 
> > We could even have some (small) statically enabled build-time buffer that could be 
> > enabled straight away before any allocators are enabled.
> 
> I'm not sure it needs to be small. We can have a persistent buffer that may be 
> resized at any time. It can start off small, or with a kernel command line, be as 
> big as you want it.

Sure.

> Basically, what ftrace has now.
> 
> Also, with a way that root user can get a handle on this buffer, and just trace 
> global events with it.

Yeah.

Thanks,

	Ingo

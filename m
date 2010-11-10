Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0KJS2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:28:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58436 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270Ab0KJS2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:28:16 -0500
Date: Wed, 10 Nov 2010 19:27:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC/Requirements/Design] h/w error reporting
Message-ID: <20101110182749.GG22410@elte.hu>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
 <20101110101450.GA18481@elte.hu>
 <1289400056.12418.139.camel@gandalf.stny.rr.com>
 <1289400234.2191.129.camel@laptop>
 <1289401781.12418.145.camel@gandalf.stny.rr.com>
 <1289403019.2084.17.camel@laptop>
 <20101110174852.GB4001@elte.hu>
 <1289412329.12418.177.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289412329.12418.177.camel@gandalf.stny.rr.com>
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

> On Wed, 2010-11-10 at 18:48 +0100, Ingo Molnar wrote:
> 
> > Yep. The obvious direction is to extend the event buffering ABI we already have, 
> > with whatever additions that are needed:
> > 
> >  - document that we already support flight recorder mode
> 
> I thought this was still broken?

Please document that as well.

> >  - a more compressed record format
> > 
> >  - NOP filler events up to page boundary, for better splice and for better flight 
> >    recorder
> > 
> >  - splice support
> > 
> > etc. That's how it evolved until now and it's all very extensible.
> > 
> > Steve, could you please list the additions you have in mind, in order of priority?
> 
> A few of things that pop up quickly are:
> 
> 1) lockless
> 
> 2) as-fast-as possible
> 
> 3) support all tasks / all CPUs and still have as-fast-as-possible

Yeah - that's a self-evident goal for just about any kernel code.

	Ingo

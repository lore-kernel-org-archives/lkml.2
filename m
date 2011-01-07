Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1AGQ7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:59:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48135 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab1AGQ7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:59:03 -0500
Date: Fri, 7 Jan 2011 17:58:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Beulich <JBeulich@novell.com>,
        "H. Peter Anvin" <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Soeren Sandmann Pedersen <sandmann@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 1/2] x86: Fix rbp saving in pt_regs on irq entry
Message-ID: <20110107165843.GA7376@elte.hu>
References: <20110106162236.GB2308@nowhere>
 <4D25FE5B020000780002AC50@vpn.id2.novell.com>
 <20110106165452.GC2308@nowhere>
 <4D2602DE020000780002ACA3@vpn.id2.novell.com>
 <20110106171231.GD2308@nowhere>
 <4D26D2C2020000780002AECB@vpn.id2.novell.com>
 <20110107123130.GB20761@elte.hu>
 <20110107160459.GA2751@nowhere>
 <4D2749D6020000780002B0BC@vpn.id2.novell.com>
 <20110107162722.GA3066@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107162722.GA3066@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, Jan 07, 2011 at 04:13:58PM +0000, Jan Beulich wrote:
> > >>> On 07.01.11 at 17:05, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > Once I'll have perf callchain based on CFI ready, we'll perhaps find some 
> > > issues
> > > there. Although I guess there are already tools that can make use of that.
> > 
> > Is this to read that you're planning to do a re-spin of the CFI
> > unwinding code (which I'm not allowed to submit another time,
> > but which we've been using for years in SuSE distros) then?
> 
> An in-kernel CFI unwinder?
> 
> No the intended CFI unwinding that I'm working on for perf is made
> on post-processing, on top of partial stack and regs snapshots.
> 
> The true unwinding is computed in userspace.

I think that design will be fundamentally more robust and more flexible than an 
in-kernel unwinder.

Thanks,

	Ingo

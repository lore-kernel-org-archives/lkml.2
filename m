Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1HEVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:25:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57254 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619Ab1HEVZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:25:24 -0400
Date: Fri, 5 Aug 2011 23:24:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
Message-ID: <20110805212409.GA21114@elte.hu>
References: <20110805205921.909038487@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805205921.909038487@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> By keeping the code separate from perf, made the transition from 
> trace-cmd to tools much easier. I've wasted too many days trying to 
> get other ways working, and I don't want to rewrite perf to do so.

But we want to move tools together, not further apart. Every code 
activity i see from you is trying to tear apart instrumentation 
tooling - while previously you agreed that it should be unified. So 
why not do tools/perf/lib/ as you agreed before?

I'm really not interested in seeing the libdrm/libdri mess repeated. 
Libraries have their uses when there's some very important external 
interface, but here it's actively harmful as it complicates and 
hardcodes APIs into ABIs that are clearly not finished yet.

Really, lets not be stupid here.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab1HFGw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 02:52:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48027 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1HFGwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 02:52:24 -0400
Date: Sat, 6 Aug 2011 08:51:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
Message-ID: <20110806065122.GC13220@elte.hu>
References: <20110805205921.909038487@goodmis.org>
 <20110805212409.GA21114@elte.hu>
 <1312592488.18583.215.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312592488.18583.215.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0001]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo, I was trying to do as you said, but to do so would require a 
> lot of restructuring of the perf code base. I started talking with 
> Arnaldo, as he's doing a lot of the work in the tools/perf code, 
> and he's the one that suggested that I do it this way. It made 
> things a lot easier.

Could you guys please talk some more and clear it up? There's 
absolutely no technical reason why tools/perf/lib/ (or 
tools/perf/libperf/) should be harder than tools/lib/.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1HFJOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 05:14:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47756 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1HFJOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 05:14:45 -0400
Date: Sat, 6 Aug 2011 11:14:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH 0/8] Having perf use libparsevent.a
Message-ID: <20110806091438.GA29727@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Arjan van de Ven <arjan@infradead.org>
References: <20110805205921.909038487@goodmis.org>
 <20110805212409.GA21114@elte.hu>
 <1312592488.18583.215.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1312592488.18583.215.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 09:01:28PM -0400, Steven Rostedt wrote:
> On Fri, 2011-08-05 at 23:24 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > By keeping the code separate from perf, made the transition from 
> > > trace-cmd to tools much easier. I've wasted too many days trying to 
> > > get other ways working, and I don't want to rewrite perf to do so.
> > 
> > But we want to move tools together, not further apart. Every code 
> > activity i see from you is trying to tear apart instrumentation 
> 
> Ouch!
> 
> Ingo, I was trying to do as you said, but to do so would require a lot
> of restructuring of the perf code base. I started talking with Arnaldo,
> as he's doing a lot of the work in the tools/perf code, and he's the one
> that suggested that I do it this way. It made things a lot easier.
> 
> Seriously, I wasted Mon-Wed trying to see how it would work in
> tools/perf. I went through iteration after iteration, and each time I
> either rewrote the tools/perf/Makefile, or hacked apart the libparsevent
> code to be strictly perf specific, and not very useful for anything
> else.

Now you feel exactly how I felt when preparing the RAS daemon stuff :-)

I think we should first agree on the design of libperf or whatever other
libraries and then start working towards it. Then we'd all know where
we're going so coding it up would be almost a routine task. And then,
other people who've done it for a couple of times already (hint: me)
could help so Steve won't have to do it alone.

Thanks.

-- 
Regards/Gruss,
    Boris.

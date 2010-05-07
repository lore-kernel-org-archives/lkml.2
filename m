Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0EGPp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:45:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32883 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab0EGPp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:45:27 -0400
X-Authority-Analysis: v=1.1 cv=OMZqYO3L41gFG4eI735GctFZkIqa2t9YKv4cWfI71LE= c=1 sm=0 a=HwkIGVdAOiAA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=Zyr8gCsZwAgOsP4ySF8A:9 a=kXoUuSEFSqquPs4s0g4A:7 a=Cm9cEmCmeThctTMx5hYhDo8xqxgA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/9 - v2][RFC] tracing: Let tracepoints have
 data?passed to tracepoint callbacks
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20100507153035.GA15267@Krystal>
References: <7a22ce9b-4c74-4818-9521-7fbccd1b8b1d@email.android.com>
	 <20100507143901.GA18408@Krystal>
	 <1273244123.22438.140.camel@gandalf.stny.rr.com>
	 <20100507150838.GB30356@Krystal>
	 <1273245338.22438.168.camel@gandalf.stny.rr.com>
	 <20100507153035.GA15267@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 07 May 2010 11:45:25 -0400
Message-ID: <1273247125.22438.202.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 11:30 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> > I'm fine with forcing all callbacks to include a data parameter if you
> > are. This would also make the changes simpler.
> 
> Yes, I am all for it.

Great! I'm making the changes now.

> 
> As for the extra type checking, it is basically just trying to force you to
> generate matching caller-callee prototypes in your CPP macros. The goal is
> really to check that the data parameter type match in both the caller and
> callee. I see that as a mean to make sure nobody is going to try to take
> shortcuts by playing with the callback types in the "undefined behavior" zone of
> the C standard in future TRACE_EVENT() modifications.

OK, I'll wait for your patch. As my favorite saying goes...

"When people ask me what language my mother tongue is, I simply reply 'C'."

-- Steve



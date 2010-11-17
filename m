Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914Ab0KQBro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:47:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36845 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab0KQBrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:47:43 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=2kSzP4yT2LoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=FKdnSa4IZ9nUF4P2UlgA:9 a=PwNadL6nVfZbsPxlmLkA:7 a=f1bksOzj2qMWJ6OnAdEoYnYwZ4UA:4 a=PUjeQqilurYA:10 a=yozPtcUpo_wwGGSf:21 a=oUQCZkKAuUaTXbff:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Steven Rostedt <rostedt@goodmis.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20101117013700.GA3290@thunk.org>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	 <20101117013700.GA3290@thunk.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 16 Nov 2010 20:47:40 -0500
Message-ID: <1289958460.30543.13.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 20:37 -0500, Ted Ts'o wrote:

> For the benefit of people who create tracepoints, what restrictions
> does trace have with respect to event types, and is this anticipated
> to change in the future?

Note, I just posted an RFC stable event patch set. I would like any tool
that does general analysis, to use stable events and not random raw
events created by the perspective maintainers.

The tool could tap into the raw events, but I don't like the "trace
check" I think anything that the trace needs should be guaranteed there
(with the stable tracepoints).

The tracepoints used for general analysis should be stable, anything
else is just shear bonus.

-- Steve



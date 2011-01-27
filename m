Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1A0TJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:09:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55898 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab1A0TJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:09:55 -0500
Date: Thu, 27 Jan 2011 20:09:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 3/3] tracepoints: Use __u64_aligned/U64_ALIGN()
Message-ID: <20110127190929.GA5944@elte.hu>
References: <20110126040459.289776311@goodmis.org>
 <20110126041014.987944521@goodmis.org>
 <20110127181907.GA5226@jolsa.brq.redhat.com>
 <1296152551.10144.80.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296152551.10144.80.camel@gandalf.stny.rr.com>
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

> On Thu, 2011-01-27 at 19:19 +0100, Jiri Olsa wrote:
> 
> > this patch breaks tracepoint section iterating for me
> > when trying to enable any event I get:
> 
> Yep we know. We are currently going through and reverting this with
> something else.

For now i've unrolled it from -tip to give this stuff some more time to cook - it's 
clearly not ready yet.

Thanks,

	Ingo

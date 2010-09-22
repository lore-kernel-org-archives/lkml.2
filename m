Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0IVSYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:24:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46761 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab0IVSYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:24:10 -0400
Date: Wed, 22 Sep 2010 20:23:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
Message-ID: <20100922182356.GB9058@elte.hu>
References: <20100917162412.GB3341@elte.hu>
 <201009180026.59482.trenn@suse.de>
 <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>
 <4C9A21AD.1000800@linux.intel.com>
 <AANLkTim6B+Je=LykgJb9=0vK5Br1rkft619BRJkBcHdP@mail.gmail.com>
 <4C9A2FB3.105@linux.intel.com>
 <1285173835.2275.1026.camel@laptop>
 <4C9A37AE.2010509@linux.intel.com>
 <1285176629.2275.1033.camel@laptop>
 <1285179355.26872.27.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285179355.26872.27.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> We could add a TRACE_EVENT_ABI() as Ingo has been suggesting. [...]

That would be rather useful.

We could still be flexible about experimental tracepoints (they dont 
hurt), but apps should stick to ABI bits - or at least not complain when 
non-ABI tracepoints change for good reasons. (arbitrary, avoidable 
changes are still bad obviously, regardless of the type of the 
tracepoint)

We'd be more stringent with marking tracepoints an ABI.

So yes, this would be lovely to have.

	Ingo

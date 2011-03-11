Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab1CKIXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 03:23:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47166 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab1CKIXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 03:23:06 -0500
Date: Fri, 11 Mar 2011 09:22:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, jan.kratochvil@redhat.com,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110311082240.GA7624@elte.hu>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110307204346.19557183C29@magilla.sf.frob.com>
 <20110309102855.GC27010@htj.dyndns.org>
 <20110310183305.GD12521@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310183305.GD12521@home.goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> I don't think perf has a good way to trace userspace yet.

uprobes are being worked on (and that comes integrated with perf), and that will 
give a good mechanism - and it (of course) wont be doing any context-switching.

Peter might be able to fill us in on the details of the review progress of the 
uprobes patches.

> ftrace focuses on the kernel.

It will hopefully be integrated into the perf ABI soon, so that developers and users 
have a unified event platform for doing tracing, profiling, event logging and more - 
all of which go back to a very similar looking event platform. (Not sure what's 
holding up that process - there's no technical roadblocks really - it 'just has to 
be done'.)

Thanks,

	Ingo

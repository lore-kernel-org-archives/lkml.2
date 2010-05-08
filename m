Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab0EHIG4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 04:06:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48527 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab0EHIGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 04:06:51 -0400
Date: Sat, 8 May 2010 10:06:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH -tip] x86,perf: P4 PMU -- protect sensible procedures
 from preemption
Message-ID: <20100508080640.GE2825@elte.hu>
References: <20100507150517.GB16434@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507150517.GB16434@lenovo>
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


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

>  arch/x86/kernel/cpu/perf_event_p4.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Looks good - but it doesnt apply cleanly to tip:master:

 Hunk #3 succeeded at 828 with fuzz 2 (offset 373 lines).
 Hunk #4 FAILED at 743.
 1 out of 4 hunks FAILED -- rejects in file arch/x86/kernel/cpu/perf_event_p4.c

is there some other patch dependency?

Thanks,

	Ingo

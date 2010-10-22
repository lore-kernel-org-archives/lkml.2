Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab0JVIFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:05:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58485 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0JVIFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:05:48 -0400
Date: Fri, 22 Oct 2010 10:05:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v2][GIT PULL] tracing: Prevent unloadable modules from
 using trace_bprintk()
Message-ID: <20101022080535.GB8474@elte.hu>
References: <1287668742.16971.585.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287668742.16971.585.camel@gandalf.stny.rr.com>
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

> 
> Ingo,
> 
> This is based off of my core-2 branch. I'm moved this patch after that
> so if anyone has any objections, I can change this patch without holding
> off the previous one.
> 
> Note, I made the TRACE_BPRINTK_ALLOWED change since it looks better.

Hm, it still looks rather fundamentally ugly, messy and assymetric. Please work out 
some better solution with the module folks. If there's really no sane solution then 
we better remove this 'speedup' API, it's just not worth it.

Thanks,

	Ingo

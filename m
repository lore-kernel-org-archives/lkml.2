Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0C2DeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 23:34:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35993 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286Ab0C2DeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 23:34:05 -0400
Date: Mon, 29 Mar 2010 05:33:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20100329033346.GA15157@elte.hu>
References: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/urgent branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/urgent
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (2):
>       perf: Correctly align perf event tracing buffer
>       perf: Use hot regs with software sched switch/migrate events
> 
> 
>  include/linux/perf_event.h      |   21 ++++++++++++++-------
>  kernel/perf_event.c             |    4 +---
>  kernel/trace/trace_event_perf.c |   11 +++++++++--
>  3 files changed, 24 insertions(+), 12 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo

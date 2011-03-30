Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab1C3HLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:11:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49343 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab1C3HLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:11:04 -0400
Date: Wed, 30 Mar 2011 09:10:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/3] perf/core improvements and fixes
Message-ID: <20110330071048.GB24029@elte.hu>
References: <1301452532-1260-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301452532-1260-1-git-send-email-acme@infradead.org>
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> 	This one has everything in acme/perf/urgent, i.e. starts the next
> tools/ devel cycle :-)
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (1):
>   perf tools: Fixup exit path when not able to open events
> 
> David Ahern (1):
>   perf tools: Emit clearer message for sys_perf_event_open ENOENT
>     return
> 
> Lin Ming (1):
>   perf probe: Add fastpath to do lookup by function name
> 
>  tools/perf/builtin-record.c    |   19 +++++++---
>  tools/perf/builtin-top.c       |   44 ++++++++++++++++--------
>  tools/perf/util/debug.c        |   10 +++++
>  tools/perf/util/debug.h        |    1 +
>  tools/perf/util/probe-finder.c |   72 ++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/probe-finder.h |    2 +
>  6 files changed, 128 insertions(+), 20 deletions(-)

Pulled, thanks Arnaldo!

Note, i merged these two also into perf/urgent:

  ca6a42586fae: perf tools: Emit clearer message for sys_perf_event_open ENOENT return
  c286c419c784: perf tools: Fixup exit path when not able to open events

as both are simple and fix real bugs.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab0GFHEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 03:04:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60348 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab0GFHEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 03:04:01 -0400
Date: Tue, 6 Jul 2010 09:03:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT PULL 0/5] perf/core enhancements and fixes
Message-ID: <20100706070349.GD16224@elte.hu>
References: <1278378276-25872-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278378276-25872-1-git-send-email-acme@infradead.org>
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

> Conny Seidel (1):
>   perf tools: Fix fallback to cplus_demangle() when bfd_demangle() is not available
> 
> Masami Hiramatsu (4):
>   tracing/kprobes: Support "string" type
>   perf probe: Support "string" type
>   perf probe: Support tracing an entry of array
>   perf probe: Support static and global variables
> 
>  Documentation/trace/kprobetrace.txt     |    2 +-
>  kernel/trace/trace_kprobe.c             |  370 ++++++++++++++++++++++++-------
>  tools/perf/Documentation/perf-probe.txt |    4 +-
>  tools/perf/Makefile                     |   48 ++--
>  tools/perf/util/probe-event.c           |   71 +++++--
>  tools/perf/util/probe-event.h           |    1 +
>  tools/perf/util/probe-finder.c          |  192 +++++++++++++----
>  7 files changed, 523 insertions(+), 165 deletions(-)

Pulled, thanks Arnaldo!

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab0DHO7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:59:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37730 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758777Ab0DHO7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:59:49 -0400
Date: Thu, 8 Apr 2010 16:59:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/6] Fixes and usability improvements
Message-ID: <20100408145936.GA24812@elte.hu>
References: <1270737529-24258-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270737529-24258-1-git-send-email-acme@infradead.org>
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
> 	Please consider pulling from:
> 
> gi://gi.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> 	Freshly rebased from tip/perf/core,
> 
> Thanks,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (4):
>   perf TUI: Show filters on the title and add help line about how to zoom out
>   perf TUI: Move "Yes" button to before "No"
>   perf tools: Reorganize some structs to save space
>   perf trace: Ignore "overwrite" field if present in /events/header_page
> 
> Randy Dunlap (2):
>   perf bench: fix spello
>   perf: cleanup some Documentation
> 
>  tools/perf/Documentation/perf-bench.txt |    6 +-
>  tools/perf/Documentation/perf-sched.txt |    4 +-
>  tools/perf/bench/sched-pipe.c           |    2 +-
>  tools/perf/builtin-sched.c              |    2 +-
>  tools/perf/builtin-timechart.c          |    2 -
>  tools/perf/util/event.h                 |    4 +-
>  tools/perf/util/header.h                |    2 +-
>  tools/perf/util/newt.c                  |   98 ++++++++++++++++++++++---------
>  tools/perf/util/probe-event.h           |    2 +-
>  tools/perf/util/probe-finder.h          |    4 +-
>  tools/perf/util/trace-event-parse.c     |   49 +++++++++++-----
>  11 files changed, 116 insertions(+), 59 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo

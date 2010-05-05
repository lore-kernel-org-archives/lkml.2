Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab0EEQtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:49:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58922 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab0EEQtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:49:00 -0400
Date: Wed, 5 May 2010 18:48:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Nick Black <dank@qemfd.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/4] perf fixes and improvements
Message-ID: <20100505164843.GA14323@elte.hu>
References: <1273069848-22934-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273069848-22934-1-git-send-email-acme@infradead.org>
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

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi Ingo,
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> Regards,
> 
> Arnaldo Carvalho de Melo (3):
>   perf report: Make dso__calc_col_width agree with hist_entry__dso_snprintf
>   perf list: Add explanation about raw hardware event descriptors
>   perf tools: Fixup minor doc formatting issues
> 
> Tom Zanussi (1):
>   perf/record: simplify TRACE_INFO tracepoint check
> 
>  tools/perf/Documentation/perf-annotate.txt     |    2 +-
>  tools/perf/Documentation/perf-bench.txt        |    2 +-
>  tools/perf/Documentation/perf-diff.txt         |    2 +-
>  tools/perf/Documentation/perf-kmem.txt         |    2 +-
>  tools/perf/Documentation/perf-list.txt         |   18 ++++++++++++++++++
>  tools/perf/Documentation/perf-trace-python.txt |    2 +-
>  tools/perf/Documentation/perf-trace.txt        |    2 +-
>  tools/perf/builtin-record.c                    |   11 +----------
>  tools/perf/util/event.c                        |    6 ++++--
>  tools/perf/util/parse-events.c                 |    2 +-
>  tools/perf/util/trace-event-info.c             |    8 +++++++-
>  11 files changed, 37 insertions(+), 20 deletions(-)

Pulled, thanks Arnaldo!

	Ingo

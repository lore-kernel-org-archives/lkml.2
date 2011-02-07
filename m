Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1BGH7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 02:59:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab1BGH7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 02:59:14 -0500
Date: Mon, 7 Feb 2011 08:58:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/6] perf/core improments
Message-ID: <20110207075851.GA28313@elte.hu>
References: <1297039337-6690-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297039337-6690-1-git-send-email-acme@infradead.org>
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
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (6):
>   perf top: Remove superfluous name_len field
>   perf annotate: Move annotate functions to util/
>   perf annotate: Support multiple histograms in annotation
>   perf annotate: Config options for symbol__tty_annotate
>   perf annotate: Separate objdump parsing from actual screen rendering
>   perf top: Ditch private annotation code, share perf annotate's
> 
>  tools/perf/Makefile                    |    2 +
>  tools/perf/builtin-annotate.c          |  276 ++--------------
>  tools/perf/builtin-report.c            |   18 +-
>  tools/perf/builtin-top.c               |  184 ++---------
>  tools/perf/util/annotate.c             |  550 ++++++++++++++++++++++++++++++++
>  tools/perf/util/annotate.h             |   94 ++++++
>  tools/perf/util/hist.c                 |  219 +-------------
>  tools/perf/util/hist.h                 |   43 +--
>  tools/perf/util/top.c                  |    5 +-
>  tools/perf/util/top.h                  |   12 +-
>  tools/perf/util/ui/browsers/annotate.c |   45 ++-
>  tools/perf/util/ui/browsers/hists.c    |    9 +-
>  12 files changed, 769 insertions(+), 688 deletions(-)
>  create mode 100644 tools/perf/util/annotate.c
>  create mode 100644 tools/perf/util/annotate.h

Pulled, thanks a lot Arnaldo!

	Ingo

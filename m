Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1FCPF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:05:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50652 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab1FCPF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:05:27 -0400
Date: Fri, 3 Jun 2011 17:05:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/9] perf/core fixes and improvements
Message-ID: <20110603150515.GA10449@elte.hu>
References: <1307048196-16387-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307048196-16387-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (3):
>   perf evlist: Remove dependency on debug routines
>   perf python: Use exception to propagate errors
>   perf evlist: Don't die if sample_{id_all|type} is invalid
> 
> David Ahern (4):
>   perf stat: clarify unsupported events from uncounted events
>   perf script: "sym" field really means show IP data
>   perf script: Make printing of dso a separate field option
>   perf script: Add printing of sample address
> 
> Frederic Weisbecker (2):
>   perf python: Fix argument name list of read_on_cpu()
>   perf python: Cleanup useless double NULL termination in method arg names
> 
>  tools/perf/Documentation/perf-script.txt |   12 ++--
>  tools/perf/builtin-script.c              |  108 +++++++++++++++++++++++++++---
>  tools/perf/builtin-stat.c                |    9 ++-
>  tools/perf/builtin-test.c                |    2 +-
>  tools/perf/util/event.c                  |   16 -----
>  tools/perf/util/event.h                  |    2 -
>  tools/perf/util/evlist.c                 |   68 +++++++++++--------
>  tools/perf/util/evlist.h                 |    6 +-
>  tools/perf/util/evsel.c                  |   17 +++++
>  tools/perf/util/evsel.h                  |    8 ++
>  tools/perf/util/python.c                 |   29 ++++----
>  tools/perf/util/session.c                |   73 ++++++++++++++-------
>  tools/perf/util/session.h                |    5 +-
>  13 files changed, 245 insertions(+), 110 deletions(-)

Pulled, thanks a lot Arnaldo!

Mind cherry-picking the fixes into perf/urgent?

Thanks,

	Ingo

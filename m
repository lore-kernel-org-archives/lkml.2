Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab1LTTfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:35:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42582 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab1LTTfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:35:32 -0500
Date: Tue, 20 Dec 2011 20:33:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Arun Sharma <asharma@fb.com>, cjashfor@linux.vnet.ibm.com,
        David Ahern <dsahern@gmail.com>, devel@openvz.org,
        Jiri Olsa <jolsa@redhat.com>,
        Johannes Schindelin <Johannes.Schindelin@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>, Nelson Elhage <nelhage@nelhage.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 00/10] perf/core improvements and fixes
Message-ID: <20111220193319.GA16440@elte.hu>
References: <1324408691-28296-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324408691-28296-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://github.com/acmel/linux.git perf/core
> 
> 	There are still patchkits I need to merge/review, thanks everybody, the
> more, the better!
> 
> 	I'll continue processing them tomorrow,
> 
> Regards,
> 
> - Arnaldo
> 
> Andrew Vagin (1):
>   perf record: Add ability to record event period
> 
> Jiri Olsa (1):
>   perf test: Add more automated tests for event parsing
> 
> Namhyung Kim (6):
>   perf report: Document '--call-graph' for optional print_limit argument
>   perf symbols: Get rid of duplicated snprintf()
>   perf symbols: Fix error path on symbol__init()
>   perf tools: Fix a memory leak on perf_read_values_destroy
>   perf tools: Remove stale git headlines from top comment
>   perf events: Tidy up perf_event__preprocess_sample
> 
> Nelson Elhage (1):
>   perf evlist: Fix errno value reporting on failed mmap
> 
> Robert Richter (1):
>   perf evsel: Fix uninitialized memory access to struct perf_sample
> 
>  tools/perf/Documentation/perf-report.txt |    5 +-
>  tools/perf/builtin-record.c              |    1 +
>  tools/perf/builtin-report.c              |    6 +-
>  tools/perf/builtin-test.c                |  127 +++++++++++++++++++++++++++++-
>  tools/perf/perf.h                        |    1 +
>  tools/perf/util/config.c                 |    5 +-
>  tools/perf/util/event.c                  |   13 ++--
>  tools/perf/util/evlist.c                 |    4 +-
>  tools/perf/util/evsel.c                  |    5 +-
>  tools/perf/util/symbol.c                 |   11 +--
>  tools/perf/util/usage.c                  |    5 +-
>  tools/perf/util/values.c                 |    1 +
>  12 files changed, 160 insertions(+), 24 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo

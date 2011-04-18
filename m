Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab1DRPhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:37:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44144 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1DRPgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:36:55 -0400
Date: Mon, 18 Apr 2011 17:36:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/2] perf/urgent fixes
Message-ID: <20110418153642.GA8623@elte.hu>
References: <1303140189-5780-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303140189-5780-1-git-send-email-acme@infradead.org>
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
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (1):
>   perf evsel: Fix use of inherit
> 
> Lin Ming (1):
>   perf hists browser: Fix seg fault when annotate null symbol
> 
>  tools/perf/builtin-record.c            |    7 +++++--
>  tools/perf/builtin-stat.c              |    7 ++++---
>  tools/perf/builtin-test.c              |   10 +++++-----
>  tools/perf/builtin-top.c               |    3 ++-
>  tools/perf/util/evlist.c               |   14 ++++++++++----
>  tools/perf/util/evsel.c                |   27 +++++++--------------------
>  tools/perf/util/evsel.h                |    6 +++---
>  tools/perf/util/python.c               |    9 +++++----
>  tools/perf/util/ui/browsers/annotate.c |    6 ++++--
>  tools/perf/util/ui/browsers/hists.c    |    2 +-
>  10 files changed, 46 insertions(+), 45 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1LLPXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:23:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59330 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1LLPXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:23:11 -0500
Date: Mon, 12 Dec 2011 13:22:55 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip:perf/core 0/8] random tiny perf fixes and cleanups
Message-ID: <20111212152255.GC2213@infradead.org>
References: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323703017-6060-1-git-send-email-namhyung@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 13, 2011 at 12:16:49AM +0900, Namhyung Kim escreveu:
> Hello,
> 
> This is a patchset for what I found during a code review.
> As you can see all of these are simple few-liners.
> Please take a look and consider applying them.

Thanks a lot, all seems ok, will apply later today to my perf/core
branch,

- Arnaldo

> Thanks.
> 
> 
> Namhyung Kim (8):
>   perf report: Document '--call-graph' for optional print_limit argument
>   perf symbols: Get rid of duplicated snprintf()
>   perf symbols: Fix error path on symbol__init()
>   perf tools: Fix a memory leak on perf_read_values_destroy
>   perf tools: Remove stale git headlines from top comment
>   perf events: Tidy up perf_event__preprocess_sample
>   perf report: Fix usage string
>   perf evlist: Fix error handling on perf_event__mmap
> 
>  tools/perf/Documentation/perf-report.txt |    5 +++--
>  tools/perf/builtin-report.c              |    8 ++++----
>  tools/perf/util/config.c                 |    7 -------
>  tools/perf/util/event.c                  |   13 +++++++------
>  tools/perf/util/evlist.c                 |    8 ++++++--
>  tools/perf/util/symbol.c                 |   11 +++--------
>  tools/perf/util/usage.c                  |    5 -----
>  tools/perf/util/values.c                 |    1 +
>  8 files changed, 24 insertions(+), 34 deletions(-)
> 
> --
> 1.7.6

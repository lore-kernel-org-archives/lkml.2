Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab0EDQdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:33:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59933 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab0EDQdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 12:33:00 -0400
Date: Tue, 4 May 2010 18:32:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/3] perf fixes (inject, report, record)
Message-ID: <20100504163232.GB1721@elte.hu>
References: <1272981607-28723-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272981607-28723-1-git-send-email-acme@infradead.org>
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
> 	Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> Regards,
> 
> - Arnaldo
> 
> Anton Blanchard (1):
>   perf: Fix performance issue with perf report
> 
> Arnaldo Carvalho de Melo (1):
>   perf inject: Add missing bits
> 
> Tom Zanussi (1):
>   perf: record TRACE_INFO only if using tracepoints and SAMPLE_RAW
> 
>  tools/perf/Documentation/perf-buildid-cache.txt |    4 +-
>  tools/perf/Documentation/perf-inject.txt        |   35 +++++++++++++++++++++++
>  tools/perf/builtin-inject.c                     |    2 +-
>  tools/perf/builtin-record.c                     |   35 +++++++++++++---------
>  tools/perf/command-list.txt                     |    1 +
>  tools/perf/util/event.c                         |    1 +
>  tools/perf/util/header.c                        |    9 +++++-
>  tools/perf/util/parse-events.h                  |    1 +
>  tools/perf/util/trace-event-info.c              |    5 +++
>  9 files changed, 75 insertions(+), 18 deletions(-)
>  create mode 100644 tools/perf/Documentation/perf-inject.txt

Pulled, thanks Arnaldo!

	Ingo

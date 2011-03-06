Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1CFWNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 17:13:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60786 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab1CFWNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 17:13:42 -0500
Date: Sun, 6 Mar 2011 23:13:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, William Cohen <wcohen@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/6] perf/core tui fixes and improvements
Message-ID: <20110306221324.GA569@elte.hu>
References: <1299444507-26549-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299444507-26549-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (6):
>   perf report tui: Fix multi event switching
>   perf hists: Remove needless global col lenght calcs
>   perf hists browser: Handle browsing empty hists tree
>   perf evlist: Split perf_evlist__id_hash
>   perf tools: Improve support for sessions with multiple events
>   perf report tui: Improve multi event session support
> 
>  tools/perf/builtin-annotate.c       |   80 +++++++++++----
>  tools/perf/builtin-report.c         |  161 +++++++++---------------------
>  tools/perf/util/event.c             |   57 +-----------
>  tools/perf/util/evlist.c            |   28 ++++--
>  tools/perf/util/evlist.h            |    3 +
>  tools/perf/util/evsel.h             |    2 +
>  tools/perf/util/header.c            |   31 ------
>  tools/perf/util/header.h            |    2 -
>  tools/perf/util/hist.c              |   15 +++-
>  tools/perf/util/hist.h              |   22 +---
>  tools/perf/util/session.c           |   63 ++++++++++++-
>  tools/perf/util/session.h           |   16 +--
>  tools/perf/util/symbol.c            |    1 -
>  tools/perf/util/symbol.h            |    1 -
>  tools/perf/util/ui/browsers/hists.c |  188 +++++++++++++++++++++++++++++-----
>  15 files changed, 383 insertions(+), 287 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo

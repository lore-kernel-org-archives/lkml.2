Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366Ab0HFHB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:01:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46681 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab0HFHBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:01:23 -0400
Date: Fri, 6 Aug 2010 09:00:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrea Gelmini <andrea.gelmini@gelma.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Julia Lawall <julia@diku.dk>,
        Masami Hiramatsu <mhiramat@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nick Piggin <npiggin@suse.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 00/10] perf/core improvements and fixes
Message-ID: <20100806070017.GA26056@elte.hu>
References: <1281059177-18747-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281059177-18747-1-git-send-email-acme@infradead.org>
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
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Andrea Gelmini (2):
>   perf probe: Remove duplicated #include
>   perf trace: Clean up #includes
> 
> Arnaldo Carvalho de Melo (7):
>   perf symbols: Store the symbol binding
>   perf ui: Add a map browser
>   perf ui: Shorten ui_browser->refresh_entries to refresh
>   perf hists: Handle verbose in hists__sort_list_width
>   perf hists: Fixup addr snprintf width on 32 bit arches
>   perf ui: Add search by name/addr to the map__browser
>   perf report: Speed up exit path
> 
> Julia Lawall (1):
>   perf timechart: Adjust confusing if indentation
> 
>  tools/perf/builtin-report.c    |   31 +++++-
>  tools/perf/builtin-timechart.c |    4 +-
>  tools/perf/builtin-trace.c     |   19 +--
>  tools/perf/util/hist.c         |    3 +
>  tools/perf/util/newt.c         |  242 +++++++++++++++++++++++++++++++++++++--
>  tools/perf/util/probe-finder.c |    1 -
>  tools/perf/util/sort.c         |    6 +-
>  tools/perf/util/symbol.c       |   30 ++++--
>  tools/perf/util/symbol.h       |    1 +
>  9 files changed, 297 insertions(+), 40 deletions(-)

Pulled, thanks Arnaldo!

	Ingo

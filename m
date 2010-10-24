Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab0JXJjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 05:39:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab0JXJjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 05:39:47 -0400
Date: Sun, 24 Oct 2010 11:39:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/5] perf/core improvements and fixes
Message-ID: <20101024093921.GA15141@elte.hu>
References: <1287865704-3880-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287865704-3880-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (2):
>   perf tools: Remove direct slang.h include
>   perf probe: Fix format specified for Dwarf_Off parameter
> 
> Ben Hutchings (2):
>   perf trace: Use $PERF_EXEC_PATH in canned report scripts
>   perf trace: Fix detection of script extension
> 
> Sonny Rao (1):
>   perf tools: Document event modifiers
> 
>  tools/perf/Documentation/perf-list.txt             |   17 +++++++++++++++++
>  tools/perf/builtin-trace.c                         |    8 ++++----
>  tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
>  tools/perf/scripts/perl/bin/rw-by-file-report      |    2 +-
>  tools/perf/scripts/perl/bin/rw-by-pid-report       |    2 +-
>  tools/perf/scripts/perl/bin/rwtop-report           |    2 +-
>  tools/perf/scripts/perl/bin/wakeup-latency-report  |    2 +-
>  tools/perf/scripts/perl/bin/workqueue-stats-report |    2 +-
>  .../python/bin/failed-syscalls-by-pid-report       |    2 +-
>  tools/perf/scripts/python/bin/netdev-times-report  |    2 +-
>  .../perf/scripts/python/bin/sched-migration-report |    2 +-
>  tools/perf/scripts/python/bin/sctop-report         |    2 +-
>  .../python/bin/syscall-counts-by-pid-report        |    2 +-
>  .../perf/scripts/python/bin/syscall-counts-report  |    2 +-
>  tools/perf/util/probe-finder.c                     |    3 ++-
>  tools/perf/util/ui/browser.c                       |    1 -
>  16 files changed, 35 insertions(+), 18 deletions(-)

Pulled, thanks Arnaldo!

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab0KJSQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:16:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54655 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab0KJSQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:16:05 -0500
Date: Wed, 10 Nov 2010 19:15:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: tzanussi@gmail.com
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/7] perf trace command-line cleanup, v2
Message-ID: <20101110181546.GE22410@elte.hu>
References: <1289412624-4772-1-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289412624-4772-1-git-send-email-tzanussi@gmail.com>
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


* tzanussi@gmail.com <tzanussi@gmail.com> wrote:

> From: Tom Zanussi <tom.zanussi@linux.intel.com>
> 
> There are currently some inconsistencies in perf trace command-line
> handling - for example, the system-wide param is hard-coded into the
> canned scripts, and the user doesn't have any option to avoid it.
> This patchset removes that limitation and cleans up some related
> complications introduced by live-mode.  It also more clearly documents
> usage, and fixes up a couple other minor problems.
> 
> This patchset can also be pulled from here:
> 
> git://github.com/zanussi/linux-2.6.git perf-trace-updates-urgent
> 
> v2 changes:
> 
> - rebased to perf/urgent
> - added Arnaldo's Acked-by to patches
> 
> Tom Zanussi (7):
>   perf trace scripting: fix some small memory leaks and missing error
>     checks
>   perf trace scripting: remove system-wide param from shell scripts
>   perf record: make the record options available outside perf record
>   perf trace record: handle commands correctly
>   perf trace: live-mode command-line cleanup
>   perf trace: update Documentation with new perf trace variants
>   perf trace: update usage
> 
>  tools/perf/Documentation/perf-trace.txt            |   57 +++++-
>  tools/perf/builtin-record.c                        |   10 +-
>  tools/perf/builtin-trace.c                         |  209 ++++++++++++++------
>  tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +-
>  tools/perf/scripts/perl/bin/rw-by-file-record      |    2 +-
>  tools/perf/scripts/perl/bin/rw-by-pid-record       |    2 +-
>  tools/perf/scripts/perl/bin/rwtop-record           |    2 +-
>  tools/perf/scripts/perl/bin/wakeup-latency-record  |    2 +-
>  tools/perf/scripts/perl/bin/workqueue-stats-record |    2 +-
>  .../python/bin/failed-syscalls-by-pid-record       |    2 +-
>  .../scripts/python/bin/futex-contention-record     |    2 +-
>  tools/perf/scripts/python/bin/netdev-times-record  |    2 +-
>  .../perf/scripts/python/bin/sched-migration-record |    2 +-
>  tools/perf/scripts/python/bin/sctop-record         |    2 +-
>  .../python/bin/syscall-counts-by-pid-record        |    2 +-
>  .../perf/scripts/python/bin/syscall-counts-record  |    2 +-
>  16 files changed, 217 insertions(+), 85 deletions(-)

Pulled, thanks a lot Tom!

	Ingo

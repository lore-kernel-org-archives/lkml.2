Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab0KJFZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 00:25:46 -0500
Received: from cpe-72-229-15-109.nyc.res.rr.com ([72.229.15.109]:33245 "EHLO
	aninha.ghostprotocols.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750755Ab0KJFZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 00:25:45 -0500
X-Greylist: delayed 28029 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2010 00:25:45 EST
Date: Tue, 9 Nov 2010 16:38:29 -0500
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: tzanussi@gmail.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [PATCH 0/7] perf trace command-line cleanup
Message-ID: <20101109213829.GB7883@ghostprotocols.net>
References: <1289337502-2492-1-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289337502-2492-1-git-send-email-tzanussi@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

	Please pull from Tom's git tree, I'm traveling and can't do
further tests, but all seems cool improvements,

Thanks a lot,

- Arnaldo

Em Tue, Nov 09, 2010 at 03:18:15PM -0600, tzanussi@gmail.com escreveu:
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
> git://github.com/zanussi/linux-2.6.git perf-trace-updates
> 
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
> 
> -- 
> Tom Zanussi, Intel Open Source Technology Center

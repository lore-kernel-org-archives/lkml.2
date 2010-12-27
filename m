Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab0L0WAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 17:00:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:40072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0L0WAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 17:00:35 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Franck Bui-Huu <fbuihuu@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Torok Edwin <edwintorok@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/4] perf/core fixes
Date: Mon, 27 Dec 2010 20:00:09 -0200
Message-Id: <1293487213-533-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (3):
  perf script: Finish the rename from trace to script
  perf record: Fix use of sample_id_all userspace with !sample_id_all kernels
  perf script: Fix event ordering settings to work with older kernels

Franck Bui-Huu (1):
  perf probe: Fix short file name probe location reporting

 tools/perf/builtin-record.c                        |   24 +++++++++++++++----
 tools/perf/builtin-script.c                        |    1 +
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |    2 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    4 +-
 tools/perf/scripts/perl/Perf-Trace-Util/README     |    4 +-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm |    2 +-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm    |    4 +-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |    4 +-
 tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
 tools/perf/scripts/perl/bin/rw-by-file-report      |    5 +---
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    5 +---
 tools/perf/scripts/perl/bin/rwtop-report           |    5 +---
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    5 +---
 tools/perf/scripts/perl/bin/workqueue-stats-report |    6 +----
 tools/perf/scripts/perl/check-perf-trace.pl        |    2 +-
 tools/perf/scripts/perl/rw-by-file.pl              |    2 +-
 tools/perf/scripts/perl/workqueue-stats.pl         |    2 +-
 .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |    2 +-
 .../Perf-Trace-Util/lib/Perf/Trace/SchedGui.py     |    2 +-
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |    2 +-
 .../python/bin/failed-syscalls-by-pid-report       |    2 +-
 .../scripts/python/bin/futex-contention-report     |    2 +-
 tools/perf/scripts/python/bin/netdev-times-report  |    2 +-
 .../perf/scripts/python/bin/sched-migration-report |    2 +-
 tools/perf/scripts/python/bin/sctop-report         |    2 +-
 .../python/bin/syscall-counts-by-pid-report        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-report  |    2 +-
 tools/perf/scripts/python/check-perf-trace.py      |    2 +-
 .../perf/scripts/python/failed-syscalls-by-pid.py  |    2 +-
 tools/perf/scripts/python/sched-migration.py       |    2 +-
 tools/perf/scripts/python/sctop.py                 |    2 +-
 tools/perf/scripts/python/syscall-counts-by-pid.py |    2 +-
 tools/perf/scripts/python/syscall-counts.py        |    2 +-
 tools/perf/util/probe-event.c                      |   14 +++++-----
 34 files changed, 62 insertions(+), 63 deletions(-)


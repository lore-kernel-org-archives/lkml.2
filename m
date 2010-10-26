Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496Ab0JZT0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:26:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:45048 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab0JZT0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:26:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Matt Fleming <matt@console-pimps.org>, Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/4] perf python scripting improvements and fixes
Date: Tue, 26 Oct 2010 17:25:41 -0200
Message-Id: <1288121145-20846-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (3):
  perf scripting: Shut up 'perf record' final status
  perf python scripting: Fixup cut'n'paste error in sctop script
  perf python scripting: Add futex-contention script

Matt Fleming (1):
  perf record: Remove newline character from perror() argument

 tools/perf/Documentation/perf-record.txt           |    4 ++
 tools/perf/builtin-record.c                        |    8 ++-
 tools/perf/builtin-trace.c                         |    9 ++--
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |   18 +++++++
 .../scripts/python/bin/futex-contention-record     |    2 +
 .../scripts/python/bin/futex-contention-report     |    4 ++
 tools/perf/scripts/python/futex-contention.py      |   50 ++++++++++++++++++++
 tools/perf/scripts/python/sctop.py                 |    2 +-
 tools/perf/util/debug.c                            |    4 +-
 tools/perf/util/debug.h                            |    2 +-
 10 files changed, 93 insertions(+), 10 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/futex-contention-record
 create mode 100644 tools/perf/scripts/python/bin/futex-contention-report
 create mode 100644 tools/perf/scripts/python/futex-contention.py

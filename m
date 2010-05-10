Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab0EJW4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:56:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:50157 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596Ab0EJWxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 00/10] perf fixes and improvements
Date: Mon, 10 May 2010 19:52:58 -0300
Message-Id: <1273531987-28956-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
LKML-Reference: <new-submission>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

Regards,

Arnaldo Carvalho de Melo (1):
  perf hist: Calculate max_sym name len and nr_entries

Tom Zanussi (9):
  perf/trace/scripting: failed-syscalls script cleanup
  perf/trace/scripting: rw-by-pid script cleanup
  perf/trace/scripting: rwtop script cleanup
  perf/trace/scripting: wakeup-latency script cleanup
  perf/trace/scripting: workqueue-stats script cleanup
  perf/trace/scripting: don't show script start/stop messages by default
  perf/trace/scripting: failed-syscalls-by-pid script cleanup
  perf/trace/scripting: syscall-counts-by-pid script cleanup
  perf/trace/scripting: syscall-counts script cleanup

 tools/perf/builtin-report.c                        |    6 +-
 tools/perf/builtin-trace.c                         |    3 +
 tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
 tools/perf/scripts/perl/failed-syscalls.pl         |    6 ++-
 tools/perf/scripts/perl/rw-by-pid.pl               |   60 ++++++++++++--------
 tools/perf/scripts/perl/rwtop.pl                   |   48 +++++++++++----
 tools/perf/scripts/perl/wakeup-latency.pl          |   12 +++-
 tools/perf/scripts/perl/workqueue-stats.pl         |   12 ++--
 .../python/bin/failed-syscalls-by-pid-report       |    2 +-
 .../python/bin/syscall-counts-by-pid-report        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-report  |    2 +-
 tools/perf/util/hist.c                             |   27 +++++++--
 tools/perf/util/hist.h                             |    4 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    3 -
 .../util/scripting-engines/trace-event-python.c    |    4 -
 tools/perf/util/symbol.c                           |    5 +-
 tools/perf/util/symbol.h                           |    1 +
 17 files changed, 128 insertions(+), 71 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1A2WVD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 17:21:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:52199 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab1A2WTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 17:19:37 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/7] perf/core improvements
Date: Sat, 29 Jan 2011 20:19:12 -0200
Message-Id: <1296339559-20914-1-git-send-email-acme@infradead.org>
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

Arnaldo Carvalho de Melo (7):
  perf record: No need to check for overwrites
  perf events: Account PERF_RECORD_LOST events in event__process
  perf evlist: Support non overwrite mode in perf_evlist__read_on_cpu
  perf top: Switch to non overwrite mode
  perf tools: Rename 'struct sample_data' to 'struct perf_sample'
  perf tools: Kill event_t typedef, use 'union perf_event' instead
  perf tools: Initial python binding

 tools/perf/builtin-annotate.c  |   11 +-
 tools/perf/builtin-diff.c      |   16 +-
 tools/perf/builtin-inject.c    |   82 ++--
 tools/perf/builtin-kmem.c      |   10 +-
 tools/perf/builtin-lock.c      |    6 +-
 tools/perf/builtin-record.c    |   80 ++--
 tools/perf/builtin-report.c    |   62 ++--
 tools/perf/builtin-sched.c     |   15 +-
 tools/perf/builtin-script.c    |   17 +-
 tools/perf/builtin-test.c      |    8 +-
 tools/perf/builtin-timechart.c |   13 +-
 tools/perf/builtin-top.c       |   48 ++-
 tools/perf/python/twatch.py    |   41 ++
 tools/perf/util/build-id.c     |   21 +-
 tools/perf/util/callchain.c    |    3 +-
 tools/perf/util/callchain.h    |    4 +-
 tools/perf/util/debug.c        |    2 +-
 tools/perf/util/debug.h        |    2 +-
 tools/perf/util/event.c        |  191 +++++----
 tools/perf/util/event.h        |   71 ++--
 tools/perf/util/evlist.c       |   41 +-
 tools/perf/util/evlist.h       |    5 +-
 tools/perf/util/evsel.c        |   11 +-
 tools/perf/util/header.c       |   83 ++--
 tools/perf/util/header.h       |   50 ++--
 tools/perf/util/hist.c         |    2 +-
 tools/perf/util/python.c       |  888 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.c      |  189 +++++-----
 tools/perf/util/session.h      |   15 +-
 tools/perf/util/setup.py       |   18 +
 30 files changed, 1493 insertions(+), 512 deletions(-)
 create mode 100755 tools/perf/python/twatch.py
 create mode 100644 tools/perf/util/python.c
 create mode 100644 tools/perf/util/setup.py


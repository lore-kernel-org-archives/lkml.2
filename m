Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0LDW1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 17:27:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:40546 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab0LDW1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 17:27:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/5] perf/core: Support for PERF_SAMPLE_ in all events
Date: Sat,  4 Dec 2010 20:26:52 -0200
Message-Id: <1291501617-6966-1-git-send-email-acme@infradead.org>
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

Arnaldo Carvalho de Melo (4):
  perf events: Separate the routines handling the PERF_SAMPLE_ identity fields
  perf events: Make sample_type identity fields available in all PERF_RECORD_ events
  perf session: Parse sample earlier
  perf tools: Ask for ID PERF_SAMPLE_ info on all PERF_RECORD_ events

Thomas Gleixner (1):
  perf events: Fix event inherit fallout of precalculated headers

 include/linux/perf_event.h               |   13 +-
 kernel/perf_event.c                      |  234 +++++++++++++++------
 tools/perf/Documentation/perf-record.txt |    5 +
 tools/perf/builtin-annotate.c            |    6 +-
 tools/perf/builtin-diff.c                |   11 +-
 tools/perf/builtin-inject.c              |   39 ++--
 tools/perf/builtin-kmem.c                |   21 +--
 tools/perf/builtin-lock.c                |   12 +-
 tools/perf/builtin-record.c              |   23 ++
 tools/perf/builtin-report.c              |   15 +-
 tools/perf/builtin-sched.c               |   21 +--
 tools/perf/builtin-script.c              |   34 +--
 tools/perf/builtin-timechart.c           |   40 ++--
 tools/perf/builtin-top.c                 |   12 +-
 tools/perf/util/build-id.c               |    7 +-
 tools/perf/util/event.c                  |  341 +++++++++++++++++++----------
 tools/perf/util/event.h                  |   27 ++-
 tools/perf/util/header.c                 |   29 ++-
 tools/perf/util/header.h                 |    1 +
 tools/perf/util/hist.h                   |    2 +
 tools/perf/util/session.c                |  159 ++++++++++++---
 tools/perf/util/session.h                |   12 +-
 22 files changed, 717 insertions(+), 347 deletions(-)


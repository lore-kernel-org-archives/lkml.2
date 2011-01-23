Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1AWB5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 20:57:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59195 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1AWB4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 20:56:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Denis Kirjanov <dkirjanov@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Pingtian Han <phan@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Renninger <trenn@suse.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/6] perf/urgent build fixes for some environments
Date: Sat, 22 Jan 2011 23:56:12 -0200
Message-Id: <1295747778-26186-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (5):
  perf test: Fix build on older glibcs
  perf tools: Fix 64 bit integer format strings
  perf tools: Add missing header, fixes build
  perf tools: Fix build when using gcc 3.4.6
  perf tools: Fix build by checking if extra warnings are supported

Thomas Renninger (1):
  perf tools: Fix time function double declaration with glibc

 tools/perf/Makefile                    |    9 +++++-
 tools/perf/builtin-annotate.c          |    6 ++--
 tools/perf/builtin-kmem.c              |    4 +-
 tools/perf/builtin-lock.c              |    6 ++--
 tools/perf/builtin-record.c            |    2 +-
 tools/perf/builtin-report.c            |    2 +-
 tools/perf/builtin-sched.c             |   20 +++++++-------
 tools/perf/builtin-script.c            |    6 ++--
 tools/perf/builtin-stat.c              |    4 +-
 tools/perf/builtin-test.c              |   47 +++++++++++++++++--------------
 tools/perf/builtin-top.c               |    9 +++---
 tools/perf/util/event.c                |    5 ++-
 tools/perf/util/header.c               |    4 +-
 tools/perf/util/hist.c                 |   17 ++++++-----
 tools/perf/util/include/linux/bitops.h |    1 +
 tools/perf/util/map.c                  |    3 +-
 tools/perf/util/parse-events.c         |    2 +-
 tools/perf/util/parse-events.h         |    2 +-
 tools/perf/util/probe-event.c          |    2 +-
 tools/perf/util/session.c              |   28 ++++++++++---------
 tools/perf/util/svghelper.c            |    9 +++---
 tools/perf/util/symbol.c               |    9 +++---
 tools/perf/util/types.h                |   10 ++++---
 tools/perf/util/ui/browsers/hists.c    |    2 +-
 tools/perf/util/ui/browsers/map.c      |    5 ++-
 tools/perf/util/values.c               |   10 +++---
 26 files changed, 123 insertions(+), 101 deletions(-)


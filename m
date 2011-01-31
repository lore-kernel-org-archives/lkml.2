Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab1AaV3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:29:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44487 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab1AaV3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:29:35 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/5] perf/core improvements
Date: Mon, 31 Jan 2011 19:29:17 -0200
Message-Id: <1296509362-28054-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (5):
  perf evlist: Move evlist methods to evlist.c
  perf evlist: Store pointer to the cpu and thread maps
  perf top: Move display agnostic routines to util/top.[ch]
  perf tools: Don't fallback to setup_pager unconditionally
  perf top: Introduce slang based TUI

 tools/perf/Makefile               |    6 +
 tools/perf/builtin-annotate.c     |    2 +-
 tools/perf/builtin-record.c       |   44 ++--
 tools/perf/builtin-report.c       |    2 +-
 tools/perf/builtin-stat.c         |   45 ++--
 tools/perf/builtin-test.c         |    6 +-
 tools/perf/builtin-top.c          |  530 ++++++++++++-------------------------
 tools/perf/python/twatch.py       |    4 +-
 tools/perf/util/cache.h           |    7 +-
 tools/perf/util/evlist.c          |  185 +++++++++++++-
 tools/perf/util/evlist.h          |   28 ++-
 tools/perf/util/evsel.c           |  144 +----------
 tools/perf/util/evsel.h           |    4 -
 tools/perf/util/python.c          |   25 +-
 tools/perf/util/top.c             |  217 +++++++++++++++
 tools/perf/util/top.h             |   80 ++++++
 tools/perf/util/ui/browsers/top.c |  136 ++++++++++
 tools/perf/util/ui/setup.c        |    5 +-
 18 files changed, 887 insertions(+), 583 deletions(-)
 create mode 100644 tools/perf/util/top.c
 create mode 100644 tools/perf/util/top.h
 create mode 100644 tools/perf/util/ui/browsers/top.c


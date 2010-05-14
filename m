Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab0ENXJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:09:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35009 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab0ENXJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:09:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/4] perf tools improvements
Date: Fri, 14 May 2010 20:09:33 -0300
Message-Id: <1273878577-12578-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (4):
  perf hist: Make event__totals per hists
  perf hist: Clarify events_stats fields usage
  perf report: Report number of events, not samples
  perf newt: Make <- zoom out filters

 tools/perf/Makefile           |    2 +
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-diff.c     |    8 ++--
 tools/perf/builtin-report.c   |   44 +++++++++++-----
 tools/perf/builtin-sched.c    |   17 ++----
 tools/perf/builtin-trace.c    |    2 +-
 tools/perf/util/event.c       |   19 ++++++-
 tools/perf/util/event.h       |    2 +
 tools/perf/util/hist.c        |  121 +++++++++++++++++++++++++----------------
 tools/perf/util/hist.h        |   24 +++++++-
 tools/perf/util/newt.c        |   46 +++++++++++++---
 tools/perf/util/pstack.c      |   75 +++++++++++++++++++++++++
 tools/perf/util/pstack.h      |   12 ++++
 tools/perf/util/session.c     |   36 +------------
 tools/perf/util/session.h     |    8 ++-
 tools/perf/util/sort.h        |   11 ++--
 tools/perf/util/util.c        |   22 ++++++++
 tools/perf/util/util.h        |    1 +
 18 files changed, 322 insertions(+), 130 deletions(-)
 create mode 100644 tools/perf/util/pstack.c
 create mode 100644 tools/perf/util/pstack.h


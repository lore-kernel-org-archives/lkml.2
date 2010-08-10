Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab0HJUQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:16:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55288 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757868Ab0HJUPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:15:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Dave Martin <dave.martin@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 0/9] perf/core fixes and improvements
Date: Tue, 10 Aug 2010 17:15:30 -0300
Message-Id: <1281471339-10878-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (8):
  perf ui: Shorten ui_browser member names
  perf ui: Move ui_helpline routines to separate file in util/ui/
  perf ui: Move ui_progress routines to separate file in util/ui/
  perf ui: Move annotate browser to util/ui/browsers/
  perf ui: Move map browser to util/ui/browsers/
  perf ui: Move hists browser to util/ui/browsers/
  perf ui: Complete the breakdown of util/newt.c
  perf annotate: Sort by hottest lines in the TUI

Dave Martin (1):
  perf symbols: Ignore mapping symbols on ARM

 tools/perf/Makefile                    |   25 +-
 tools/perf/builtin-annotate.c          |    2 +-
 tools/perf/util/debug.c                |    2 +-
 tools/perf/util/debug.h                |    9 +-
 tools/perf/util/hist.c                 |   13 +-
 tools/perf/util/hist.h                 |    3 +-
 tools/perf/util/newt.c                 | 1487 --------------------------------
 tools/perf/util/pstack.h               |    2 +
 tools/perf/util/symbol.c               |   10 +
 tools/perf/util/ui/browser.c           |   57 +-
 tools/perf/util/ui/browser.h           |    7 +-
 tools/perf/util/ui/browsers/annotate.c |  191 ++++
 tools/perf/util/ui/browsers/hists.c    |  946 ++++++++++++++++++++
 tools/perf/util/ui/browsers/map.c      |  163 ++++
 tools/perf/util/ui/browsers/map.h      |    6 +
 tools/perf/util/ui/helpline.c          |   69 ++
 tools/perf/util/ui/helpline.h          |   10 +
 tools/perf/util/ui/libslang.h          |   27 +
 tools/perf/util/ui/progress.c          |   60 ++
 tools/perf/util/ui/progress.h          |   11 +
 tools/perf/util/ui/setup.c             |   42 +
 tools/perf/util/ui/util.c              |  114 +++
 tools/perf/util/ui/util.h              |   10 +
 23 files changed, 1729 insertions(+), 1537 deletions(-)
 delete mode 100644 tools/perf/util/newt.c
 create mode 100644 tools/perf/util/ui/browsers/annotate.c
 create mode 100644 tools/perf/util/ui/browsers/hists.c
 create mode 100644 tools/perf/util/ui/browsers/map.c
 create mode 100644 tools/perf/util/ui/browsers/map.h
 create mode 100644 tools/perf/util/ui/helpline.c
 create mode 100644 tools/perf/util/ui/helpline.h
 create mode 100644 tools/perf/util/ui/libslang.h
 create mode 100644 tools/perf/util/ui/progress.c
 create mode 100644 tools/perf/util/ui/progress.h
 create mode 100644 tools/perf/util/ui/setup.c
 create mode 100644 tools/perf/util/ui/util.c
 create mode 100644 tools/perf/util/ui/util.h


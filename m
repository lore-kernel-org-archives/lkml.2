Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1BGAnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 19:43:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:42892 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab1BGAnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 19:43:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/6] perf/core improments
Date: Sun,  6 Feb 2011 22:42:11 -0200
Message-Id: <1297039337-6690-1-git-send-email-acme@infradead.org>
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

Arnaldo Carvalho de Melo (6):
  perf top: Remove superfluous name_len field
  perf annotate: Move annotate functions to util/
  perf annotate: Support multiple histograms in annotation
  perf annotate: Config options for symbol__tty_annotate
  perf annotate: Separate objdump parsing from actual screen rendering
  perf top: Ditch private annotation code, share perf annotate's

 tools/perf/Makefile                    |    2 +
 tools/perf/builtin-annotate.c          |  276 ++--------------
 tools/perf/builtin-report.c            |   18 +-
 tools/perf/builtin-top.c               |  184 ++---------
 tools/perf/util/annotate.c             |  550 ++++++++++++++++++++++++++++++++
 tools/perf/util/annotate.h             |   94 ++++++
 tools/perf/util/hist.c                 |  219 +-------------
 tools/perf/util/hist.h                 |   43 +--
 tools/perf/util/top.c                  |    5 +-
 tools/perf/util/top.h                  |   12 +-
 tools/perf/util/ui/browsers/annotate.c |   45 ++-
 tools/perf/util/ui/browsers/hists.c    |    9 +-
 12 files changed, 769 insertions(+), 688 deletions(-)
 create mode 100644 tools/perf/util/annotate.c
 create mode 100644 tools/perf/util/annotate.h


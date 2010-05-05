Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934930Ab0EEObt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:31:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41412 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933775Ab0EEOa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:30:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Nick Black <dank@qemfd.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/4] perf fixes and improvements
Date: Wed,  5 May 2010 11:30:44 -0300
Message-Id: <1273069848-22934-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

Regards,

Arnaldo Carvalho de Melo (3):
  perf report: Make dso__calc_col_width agree with hist_entry__dso_snprintf
  perf list: Add explanation about raw hardware event descriptors
  perf tools: Fixup minor doc formatting issues

Tom Zanussi (1):
  perf/record: simplify TRACE_INFO tracepoint check

 tools/perf/Documentation/perf-annotate.txt     |    2 +-
 tools/perf/Documentation/perf-bench.txt        |    2 +-
 tools/perf/Documentation/perf-diff.txt         |    2 +-
 tools/perf/Documentation/perf-kmem.txt         |    2 +-
 tools/perf/Documentation/perf-list.txt         |   18 ++++++++++++++++++
 tools/perf/Documentation/perf-trace-python.txt |    2 +-
 tools/perf/Documentation/perf-trace.txt        |    2 +-
 tools/perf/builtin-record.c                    |   11 +----------
 tools/perf/util/event.c                        |    6 ++++--
 tools/perf/util/parse-events.c                 |    2 +-
 tools/perf/util/trace-event-info.c             |    8 +++++++-
 11 files changed, 37 insertions(+), 20 deletions(-)


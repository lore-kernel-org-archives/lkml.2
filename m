Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab1CWWx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:53:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58254 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932943Ab1CWWxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:53:10 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arun Sharma <asharma@fb.com>, Avi Kivity <avi@redhat.com>,
        Dave Martin <dave.martin@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Zhang Yanmin <yanmin_zhang@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/3] perf/core fixes and improvements
Date: Wed, 23 Mar 2011 19:52:44 -0300
Message-Id: <1300920767-936-1-git-send-email-acme@infradead.org>
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

Arnaldo Carvalho de Melo (3):
  perf session: Pass evsel in event_ops->sample()
  perf build-id: Add quirk to deal with perf.data file format breakage
  perf symbols: Look at .dynsym again if .symtab not found

 tools/perf/builtin-annotate.c                      |   18 ++-----
 tools/perf/builtin-diff.c                          |    1 +
 tools/perf/builtin-inject.c                        |   11 ++++-
 tools/perf/builtin-kmem.c                          |    1 +
 tools/perf/builtin-lock.c                          |    4 +-
 tools/perf/builtin-report.c                        |   19 ++-----
 tools/perf/builtin-sched.c                         |    1 +
 tools/perf/builtin-script.c                        |   15 ++----
 tools/perf/builtin-timechart.c                     |   11 ++++
 tools/perf/util/build-id.c                         |    1 +
 tools/perf/util/header.c                           |   57 +++++++++++++++++++-
 tools/perf/util/hist.h                             |    1 +
 .../perf/util/scripting-engines/trace-event-perl.c |    1 +
 .../util/scripting-engines/trace-event-python.c    |    1 +
 tools/perf/util/session.c                          |   25 ++++++++-
 tools/perf/util/session.h                          |    7 ++-
 tools/perf/util/symbol.c                           |   25 +++++----
 tools/perf/util/trace-event-scripting.c            |    1 +
 tools/perf/util/trace-event.h                      |    1 +
 19 files changed, 142 insertions(+), 59 deletions(-)


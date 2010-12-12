Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0LLPKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 10:10:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:60988 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab0LLPK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 10:10:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/2] perf/core improvements
Date: Sun, 12 Dec 2010 13:10:06 -0200
Message-Id: <1292166608-20770-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Ian Munsie (2):
  perf session: Fallback to unordered processing if no sample_id_all
  perf record,report,annotate,diff: Process events in order

 tools/perf/builtin-annotate.c     |    4 +++-
 tools/perf/builtin-buildid-list.c |    3 ++-
 tools/perf/builtin-diff.c         |    6 ++++--
 tools/perf/builtin-inject.c       |    2 +-
 tools/perf/builtin-kmem.c         |    3 ++-
 tools/perf/builtin-lock.c         |    2 +-
 tools/perf/builtin-record.c       |    7 +++++--
 tools/perf/builtin-report.c       |    4 +++-
 tools/perf/builtin-sched.c        |    3 ++-
 tools/perf/builtin-script.c       |    2 +-
 tools/perf/builtin-timechart.c    |    3 ++-
 tools/perf/builtin-top.c          |    2 +-
 tools/perf/util/session.c         |   11 ++++++++++-
 tools/perf/util/session.h         |    5 ++++-
 14 files changed, 41 insertions(+), 16 deletions(-)


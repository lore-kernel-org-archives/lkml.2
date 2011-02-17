Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab1BQUlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:41:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38674 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab1BQUlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:41:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arun Sharma <arun@sharma-home.net>,
        "David S . Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/5] perf/core improvements and fixes
Date: Thu, 17 Feb 2011 18:41:26 -0200
Message-Id: <1297975291-12792-1-git-send-email-acme@infradead.org>
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

Arnaldo Carvalho de Melo (4):
  perf python: Add cgroup.c to setup.py to get it building again
  perf hists: Print number of samples, not the period sum
  perf record: Delay setting the header writing atexit call
  perf report: Tell the user when a perf.data file has no samples

Stephane Eranian (1):
  perf: make perf stat print user provided full event names

 tools/perf/builtin-record.c    |   10 +++++-----
 tools/perf/builtin-report.c    |    6 ++++++
 tools/perf/util/evsel.c        |    1 +
 tools/perf/util/evsel.h        |    7 +++++++
 tools/perf/util/hist.c         |    7 +++++--
 tools/perf/util/parse-events.c |   10 ++++++++++
 tools/perf/util/setup.py       |    2 +-
 7 files changed, 35 insertions(+), 8 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1FBU5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 16:57:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:36248 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1FBU4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 16:56:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/9] perf/core fixes and improvements
Date: Thu,  2 Jun 2011 17:56:27 -0300
Message-Id: <1307048196-16387-1-git-send-email-acme@infradead.org>
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

Arnaldo Carvalho de Melo (3):
  perf evlist: Remove dependency on debug routines
  perf python: Use exception to propagate errors
  perf evlist: Don't die if sample_{id_all|type} is invalid

David Ahern (4):
  perf stat: clarify unsupported events from uncounted events
  perf script: "sym" field really means show IP data
  perf script: Make printing of dso a separate field option
  perf script: Add printing of sample address

Frederic Weisbecker (2):
  perf python: Fix argument name list of read_on_cpu()
  perf python: Cleanup useless double NULL termination in method arg names

 tools/perf/Documentation/perf-script.txt |   12 ++--
 tools/perf/builtin-script.c              |  108 +++++++++++++++++++++++++++---
 tools/perf/builtin-stat.c                |    9 ++-
 tools/perf/builtin-test.c                |    2 +-
 tools/perf/util/event.c                  |   16 -----
 tools/perf/util/event.h                  |    2 -
 tools/perf/util/evlist.c                 |   68 +++++++++++--------
 tools/perf/util/evlist.h                 |    6 +-
 tools/perf/util/evsel.c                  |   17 +++++
 tools/perf/util/evsel.h                  |    8 ++
 tools/perf/util/python.c                 |   29 ++++----
 tools/perf/util/session.c                |   73 ++++++++++++++-------
 tools/perf/util/session.h                |    5 +-
 13 files changed, 245 insertions(+), 110 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab0EQTbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:31:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:54389 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab0EQTbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:31:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/4] perf options type checking
Date: Mon, 17 May 2010 16:31:14 -0300
Message-Id: <1274124678-24781-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
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
  perf options: Introduce OPT_UINTEGER
  perf options: Check v type in OPT_U?INTEGER
  perf options: Type check OPT_BOOLEAN and fix the offenders
  perf options: Type check all the remaining OPT_ variants

 tools/perf/bench/sched-messaging.c     |    6 ++----
 tools/perf/builtin-bench.c             |    4 ++--
 tools/perf/builtin-help.c              |    6 +++---
 tools/perf/builtin-kvm.c               |    6 +++---
 tools/perf/builtin-lock.c              |    3 +--
 tools/perf/builtin-record.c            |    8 +++-----
 tools/perf/builtin-report.c            |    4 ++--
 tools/perf/builtin-sched.c             |    8 ++++----
 tools/perf/builtin-test.c              |    2 +-
 tools/perf/builtin-top.c               |    7 +++----
 tools/perf/perf.h                      |    3 ++-
 tools/perf/util/hist.c                 |    2 +-
 tools/perf/util/include/linux/kernel.h |    2 ++
 tools/perf/util/parse-options.c        |   32 +++++++++++++++++++++++++-------
 tools/perf/util/parse-options.h        |   27 +++++++++++++++++----------
 tools/perf/util/sort.c                 |    8 ++++----
 tools/perf/util/sort.h                 |    8 ++++----
 tools/perf/util/symbol.h               |    2 +-
 18 files changed, 80 insertions(+), 58 deletions(-)


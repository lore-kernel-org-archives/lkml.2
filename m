Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab1AEREa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:04:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:35827 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab1AERE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:04:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/5] perf/core fixes and cleanups
Date: Wed,  5 Jan 2011 15:04:01 -0200
Message-Id: <1294247046-32352-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

	I removed the patch that introduced map__empty and caused those
aliasing problems on f12 i386, I tried but couldn't reproduce it on a f14
i386 machine, will investigate more later.

	The synch of master.k.o to g.k.o these days is taking a long time, so
beware.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (4):
  perf test: Clarify some error reports in the open syscall test
  perf session: Warn about errors when processing pipe events too
  perf script: Use the default lost event handler
  perf script: Make some lists static

Stephane Eranian (1):
  perf tools: Fix perf_event.h header usage

 tools/perf/builtin-script.c    |   19 ++-----------
 tools/perf/builtin-test.c      |   18 +++++++-----
 tools/perf/util/evsel.h        |    2 +-
 tools/perf/util/parse-events.h |    2 +-
 tools/perf/util/session.c      |   57 +++++++++++++++++++++------------------
 5 files changed, 47 insertions(+), 51 deletions(-)


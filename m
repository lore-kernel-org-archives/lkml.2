Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab0K3ULo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:11:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:33396 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab0K3ULW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:11:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL 00/11] perf/core performance improvements
Date: Tue, 30 Nov 2010 18:10:45 -0200
Message-Id: <1291147856-17459-1-git-send-email-acme@infradead.org>
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

Arnaldo Carvalho de Melo (2):
  perf events: Precalculate the header space for PERF_SAMPLE_ fields
  perf debug: Simplify trace_event

Thomas Gleixner (9):
  perf session: Fix list sort algorithm
  perf session: Use appropriate pointer type instead of silly typecasting
  perf session: Cleanup __perf_session__process_events()
  perf session: Move ui_progress_update in __perf_session__process_events()
  perf session: Simplify termination checks
  perf session: Use sensible mmap size
  perf session: Keep file mmaped instead of malloc/memcpy
  perf session: Cache sample objects
  perf session: Allocate chunks of sample objects

 include/linux/perf_event.h |    2 +
 kernel/perf_event.c        |  150 ++++++++++++++---------
 tools/perf/util/debug.c    |   41 ++-----
 tools/perf/util/session.c  |  289 ++++++++++++++++++++++++--------------------
 tools/perf/util/session.h  |    8 +-
 5 files changed, 269 insertions(+), 221 deletions(-)


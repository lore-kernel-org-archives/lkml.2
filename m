Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab0KZVrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:47:51 -0500
Received: from canuck.infradead.org ([134.117.69.58]:57363 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0KZVrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:47:49 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Davidlohr Bueso <dave@gnu.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/5] perf/core improvements and fixes
Date: Fri, 26 Nov 2010 19:47:16 -0200
Message-Id: <1290808041-16535-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf record: Add option to disable collecting build-ids
  perf events: Default to using event__process_lost

Davidlohr Bueso (1):
  perf tools: Add GCC optimization to memory allocating functions

Ian Munsie (1):
  perf symbols: Correct final kernel map guesses

Shawn Bohrer (1):
  perf trace: Handle DT_UNKNOWN on filesystems that don't support
    d_type

 tools/perf/builtin-record.c            |   14 ++++++++++--
 tools/perf/builtin-trace.c             |   33 ++++++++++++++++++++++++-------
 tools/perf/util/event.c                |    2 +-
 tools/perf/util/header.c               |   11 ++++++++-
 tools/perf/util/header.h               |    1 +
 tools/perf/util/include/linux/bitops.h |    5 ++++
 tools/perf/util/session.c              |    2 +-
 tools/perf/util/symbol.c               |    2 +-
 tools/perf/util/util.h                 |    5 ++-
 9 files changed, 57 insertions(+), 18 deletions(-)


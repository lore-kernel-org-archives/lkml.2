Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab0LFUdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:33:52 -0500
Received: from canuck.infradead.org ([134.117.69.58]:57341 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab0LFUdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:33:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Chris Samuel <chris@csamuel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/5] perf/core improvements and fixes
Date: Mon,  6 Dec 2010 18:28:13 -0200
Message-Id: <1291667298-7238-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

	This is in addition to the previous pull request.

Regards,

- Arnaldo

Akihiro Nagai (1):
  perf options: add OPT_CALLBACK_DEFAULT_NOOPT

Chris Samuel (1):
  perf tools: Catch a few uncheck calloc/malloc's

Ian Munsie (1):
  perf hist: Better displaying of unresolved DSOs and symbols

Stephane Eranian (1):
  perf script: Fix compiler warning in builtin_script.c:is_top_script()

Thomas Gleixner (1):
  perf session: Sort all events if ordered_samples=true

 tools/perf/builtin-kmem.c       |    3 +
 tools/perf/builtin-lock.c       |    3 +
 tools/perf/builtin-sched.c      |    3 +
 tools/perf/builtin-script.c     |   10 ++--
 tools/perf/builtin-timechart.c  |    3 +
 tools/perf/util/header.c        |    3 +
 tools/perf/util/parse-options.h |    4 +
 tools/perf/util/session.c       |  125 ++++++++++++++++++++++----------------
 tools/perf/util/sort.c          |    6 +-
 9 files changed, 99 insertions(+), 61 deletions(-)


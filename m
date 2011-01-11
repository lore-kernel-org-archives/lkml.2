Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab1AKA2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:28:48 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40145 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab1AKA21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:28:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Chris Samuel <chris@csamuel.org>, David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Pirko <jpirko@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/6] perf/urgent fixes and improvements
Date: Mon, 10 Jan 2011 22:28:06 -0200
Message-Id: <1294705692-9537-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (4):
  perf sched: Fix allocation result check
  perf tools: Emit clearer message for sys_perf_event_open ENOENT return
  perf evsel: Support perf_evsel__open(cpus > 1 && threads > 1)
  perf session: Fix infinite loop in __perf_session__process_events

David Ahern (1):
  perf stat: better error message for unsupported events

Jiri Pirko (1):
  perf sched: Use PTHREAD_STACK_MIN to avoid pthread_attr_setstacksize() fail

 tools/perf/builtin-record.c |    3 +
 tools/perf/builtin-sched.c  |    5 +-
 tools/perf/builtin-stat.c   |    2 +
 tools/perf/builtin-test.c   |  110 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin-top.c    |    2 +
 tools/perf/util/evsel.c     |   82 +++++++++++++++++++-------------
 tools/perf/util/session.c   |    2 +-
 7 files changed, 170 insertions(+), 36 deletions(-)


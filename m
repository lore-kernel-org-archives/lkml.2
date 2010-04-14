Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab0DNWJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:09:53 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51221 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab0DNWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:09:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U8RCuLXE9J7VVA7KWZpKXfxF4Y3kcsVY4GxD66awiXXtGCn7di4m0Ay8jvJrWxs0Uk
         P4CZlPnhPpdzLyOUuzEmsv2GhoXwGcnD3YL7yHdDzaLb9Vcg0qfJ8yHLB46jCLEfZJYz
         l9bpbyExIKMqb1OYxPy3N9j7Py/40p2muL18I=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] perf updates, again
Date: Thu, 15 Apr 2010 00:09:50 +0200
Message-Id: <1271282990-24259-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Thanks,
	Frederic
---

Frederic Weisbecker (4):
      perf: Fix hlist related build error
      perf: Make -f the default for perf record
      perf: Always record tracepoints raw samples from perf record
      perf: Make the trace events sample period default to 1

Thomas Gleixner (1):
      perf: Fix dynamic field detection


 kernel/perf_event.c                      |   60 ++++++++++++------------
 tools/perf/Documentation/perf-record.txt |    4 +-
 tools/perf/builtin-record.c              |   76 ++++++++++++++++++-----------
 tools/perf/util/parse-events.c           |   16 ++----
 tools/perf/util/trace-event-parse.c      |    2 +-
 5 files changed, 86 insertions(+), 72 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab0C1FLK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 01:11:10 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55123 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab0C1FLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 01:11:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dkN4rVYNJhABwq3d8e9F+/7afc6z7J4jmHgfzHC9z8CZ3eLRgv3phuXomZsOKFLT4v
         CRsn7CP4EjhF74nltgnxZL4GcK4qs+vb9PnPGrpGBXRxWkd4fWchSWRNvHsf+b4wiyTZ
         cDPXCsIAaNMk4WxcsOWRBq69ez8/80YO5tyzE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] perf fixes
Date: Sun, 28 Mar 2010 07:11:04 +0200
Message-Id: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Frederic Weisbecker (2):
      perf: Correctly align perf event tracing buffer
      perf: Use hot regs with software sched switch/migrate events


 include/linux/perf_event.h      |   21 ++++++++++++++-------
 kernel/perf_event.c             |    4 +---
 kernel/trace/trace_event_perf.c |   11 +++++++++--
 3 files changed, 24 insertions(+), 12 deletions(-)

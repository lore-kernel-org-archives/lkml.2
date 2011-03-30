Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1C3Cfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:35:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54820 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab1C3Cfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:35:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/3] perf/core improvements and fixes
Date: Tue, 29 Mar 2011 23:35:29 -0300
Message-Id: <1301452532-1260-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

	This one has everything in acme/perf/urgent, i.e. starts the next
tools/ devel cycle :-)

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf tools: Fixup exit path when not able to open events

David Ahern (1):
  perf tools: Emit clearer message for sys_perf_event_open ENOENT
    return

Lin Ming (1):
  perf probe: Add fastpath to do lookup by function name

 tools/perf/builtin-record.c    |   19 +++++++---
 tools/perf/builtin-top.c       |   44 ++++++++++++++++--------
 tools/perf/util/debug.c        |   10 +++++
 tools/perf/util/debug.h        |    1 +
 tools/perf/util/probe-finder.c |   72 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-finder.h |    2 +
 6 files changed, 128 insertions(+), 20 deletions(-)


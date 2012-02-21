Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2BURgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:36:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:41223 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab2BURf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:35:57 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Danny Kukawka <danny.kukawka@bisect.de>,
        Danny Kukawka <dkukawka@suse.de>, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Jovi Zhang <bookjovi@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/3] perf/core fixes and improvements
Date: Tue, 21 Feb 2012 15:35:24 -0200
Message-Id: <1329845727-21512-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 09bda4432a8a4d4db2b2b94697abc8d732a9ff73:

  Merge branch 'tip/perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/core (2012-02-17 12:55:07 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf-core-for-mingo

for you to fetch changes up to 6b1bee9035d430c4b4f586df6df4b3f840e89b5b:

  perf tools: fix broken perf record -a mode (2012-02-21 15:05:43 -0200)

----------------------------------------------------------------
Important fix from Stephane for system wide monitoring, problem
introduced recently in the pid list patches.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Danny Kukawka (1):
      perf tools: Remove duplicated string.h includes

Stefan Hajnoczi (1):
      perf tools: Allow expressions in __print_symbolic() fields

Stephane Eranian (1):
      perf tools: fix broken perf record -a mode

 tools/perf/util/probe-event.c       |    1 -
 tools/perf/util/thread_map.c        |    2 +-
 tools/perf/util/trace-event-parse.c |   12 ++++++++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab1J2R0I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 13:26:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:35439 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933557Ab1J2R0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 13:26:05 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, yrl.pp-manager.tt@hitachi.com,
        arnaldo.melo@gmail.com
Subject: [GIT PULL 0/3] perf/core fixes and improvements
Date: Sat, 29 Oct 2011 15:25:48 -0200
Message-Id: <1319909151-11432-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf hists browser: Warn about lost events
  perf report: Add progress bar when processing time ordered events

Masami Hiramatsu (1):
  perf tools: Fix a typo of command name as trace-cmd

 tools/perf/builtin-top.c            |   41 +++++++++++++++++++++--------
 tools/perf/util/hist.h              |    1 +
 tools/perf/util/session.c           |   38 ++++++++++++++++++++++----
 tools/perf/util/session.h           |    1 +
 tools/perf/util/top.h               |    1 -
 tools/perf/util/trace-event-info.c  |    2 +-
 tools/perf/util/ui/browser.c        |   21 ++++++++++++---
 tools/perf/util/ui/browser.h        |    3 +-
 tools/perf/util/ui/browsers/hists.c |   49 ++++++++++++++++++++++++++++++----
 9 files changed, 127 insertions(+), 30 deletions(-)


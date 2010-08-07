Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762442Ab0HGBe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 21:34:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab0HGBeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 21:34:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 0/4] perf/core fixes and improvements
Date: Fri,  6 Aug 2010 22:34:05 -0300
Message-Id: <1281144849-22896-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
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
  perf ui: Introduce list_head based generic ui_browser refresh routine
  perf ui: Start breaking down newt.c into multiple files

Masami Hiramatsu (2):
  perf probe: Fix to copy the type for raw parameters
  perf probe: Fix memory leaks in add_perf_probe_events

 tools/perf/Makefile                  |   10 +-
 tools/perf/util/include/linux/list.h |    8 +
 tools/perf/util/newt.c               |  343 +++-------------------------------
 tools/perf/util/probe-event.c        |   11 +-
 tools/perf/util/probe-finder.c       |    8 +-
 tools/perf/util/ui/browser.c         |  313 +++++++++++++++++++++++++++++++
 tools/perf/util/ui/browser.h         |   43 +++++
 7 files changed, 408 insertions(+), 328 deletions(-)
 create mode 100644 tools/perf/util/ui/browser.c
 create mode 100644 tools/perf/util/ui/browser.h


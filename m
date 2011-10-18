Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab1JRVoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 17:44:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:49908 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab1JRVoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 17:44:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 0/7] perf/core fixes and improvements
Date: Tue, 18 Oct 2011 19:44:00 -0200
Message-Id: <1318974247-6683-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

	The TUI now should be much closer to the old 'perf top' stdio
visual/experience, more on that vein in the next pull req.

- Arnaldo

Arnaldo Carvalho de Melo (7):
  perf hists browser: Add missing hotkeys to the help window
  perf tui: Catch signals to exit gracefully
  perf ui browser: Allow initial use without navigation UI elements
  perf hists: Don't format the percentage on hist_entry__snprintf
  perf tui: Remove unneeded call to newtCls on startup
  perf ui browser: Make the colors configurable and change the defaults
  perf top tui: Give color hints just on the percentage, like on --stdio

 tools/perf/Documentation/perfconfig.example |   20 ++++
 tools/perf/util/hist.c                      |   29 ++++--
 tools/perf/util/hist.h                      |    4 +-
 tools/perf/util/ui/browser.c                |  127 ++++++++++++++++++++++-----
 tools/perf/util/ui/browser.h                |    2 +
 tools/perf/util/ui/browsers/annotate.c      |    6 ++
 tools/perf/util/ui/browsers/hists.c         |   51 ++++++-----
 tools/perf/util/ui/setup.c                  |   25 +++++-
 8 files changed, 203 insertions(+), 61 deletions(-)
 create mode 100644 tools/perf/Documentation/perfconfig.example

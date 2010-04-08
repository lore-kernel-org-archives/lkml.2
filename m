Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab0DHOi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:38:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36200 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab0DHOix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:38:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: [PATCH 0/6] Fixes and usability improvements
Date: Thu,  8 Apr 2010 11:38:43 -0300
Message-Id: <1270737529-24258-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling from:

gi://gi.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

	Freshly rebased from tip/perf/core,

Thanks,

- Arnaldo

Arnaldo Carvalho de Melo (4):
  perf TUI: Show filters on the title and add help line about how to zoom out
  perf TUI: Move "Yes" button to before "No"
  perf tools: Reorganize some structs to save space
  perf trace: Ignore "overwrite" field if present in /events/header_page

Randy Dunlap (2):
  perf bench: fix spello
  perf: cleanup some Documentation

 tools/perf/Documentation/perf-bench.txt |    6 +-
 tools/perf/Documentation/perf-sched.txt |    4 +-
 tools/perf/bench/sched-pipe.c           |    2 +-
 tools/perf/builtin-sched.c              |    2 +-
 tools/perf/builtin-timechart.c          |    2 -
 tools/perf/util/event.h                 |    4 +-
 tools/perf/util/header.h                |    2 +-
 tools/perf/util/newt.c                  |   98 ++++++++++++++++++++++---------
 tools/perf/util/probe-event.h           |    2 +-
 tools/perf/util/probe-finder.h          |    4 +-
 tools/perf/util/trace-event-parse.c     |   49 +++++++++++-----
 11 files changed, 116 insertions(+), 59 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab2I1JkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:40:20 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59302 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab2I1JkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:40:19 -0400
X-AuditID: 9c930197-b7b6dae000000e70-5e-50657081a5aa
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/12] perf tools: Makefile and related cleanups
Date: Fri, 28 Sep 2012 18:31:56 +0900
Message-Id: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is what I found during reading the Makefile.  Main goal is using
positive macro name to reduce confusing when dealing with #ifdef's.

You can get it from my tree too:

git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git  perf/makefile

Any comments are welcome, thanks.
Namhyung


Namhyung Kim (12):
  perf tools: Move libdw availability check before arch Makefile
  perf tools: Remove unused PYRF_OBJS variable on Makefile
  perf tools: Convert to LIBELF_SUPPORT
  perf tools: Convert to LIBUNWIND_SUPPORT
  perf tools: Convert to LIBAUDIT_SUPPORT
  perf tools: Convert to NEWT_SUPPORT
  perf tools: Convert to GTK2_SUPPORT
  perf tools: Convert to LIBPERL_SUPPORT
  perf tools: Convert to LIBPYTHON_SUPPORT
  perf tools: Convert to DEMANGLE_SUPPORT
  perf tools: Convert to BACKTRACE_SUPPORT
  perf tools: Convert to HAVE_STRLCPY

 tools/perf/Makefile                     | 114 ++++++++++++--------------------
 tools/perf/builtin-inject.c             |   2 +-
 tools/perf/builtin-record.c             |  14 ++--
 tools/perf/builtin-script.c             |   4 +-
 tools/perf/perf.c                       |   4 +-
 tools/perf/ui/gtk/util.c                |   2 +-
 tools/perf/ui/helpline.h                |  18 ++---
 tools/perf/util/annotate.h              |   8 +--
 tools/perf/util/cache.h                 |  38 ++++++-----
 tools/perf/util/debug.c                 |   2 +-
 tools/perf/util/debug.h                 |  17 ++---
 tools/perf/util/generate-cmdlist.sh     |   4 +-
 tools/perf/util/hist.h                  |  27 ++++----
 tools/perf/util/map.c                   |   2 +-
 tools/perf/util/path.c                  |   2 +-
 tools/perf/util/perf_regs.h             |   4 +-
 tools/perf/util/symbol.h                |  29 ++++----
 tools/perf/util/trace-event-scripting.c |  20 +++---
 tools/perf/util/unwind.h                |   4 +-
 tools/perf/util/util.c                  |   4 +-
 20 files changed, 149 insertions(+), 170 deletions(-)

-- 
1.7.11.4


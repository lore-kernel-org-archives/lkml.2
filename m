Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1JMPIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:08:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53103 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab1JMPIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:08:36 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/6] perf/core fixes and improvements
Date: Thu, 13 Oct 2011 12:08:18 -0300
Message-Id: <1318518504-23299-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (5):
  perf hists browser: Recalculate browser pointers after resort/decay
  perf hists: Don't free decayed entries if in the annotation browser
  perf ui browser: Handle SIGWINCH
  perf ui browser: Remove ui_browser__add_exit_keys
  perf top: Remove entries from entries_collapsed on decay

Stephane Eranian (1):
  perf hists: Fix compilation when NO_NEWT_SUPPORT is set

 tools/perf/builtin-top.c               |   23 ++++-
 tools/perf/perf.c                      |   24 +++++
 tools/perf/perf.h                      |    2 +
 tools/perf/util/hist.c                 |   24 ++++-
 tools/perf/util/hist.h                 |   11 ++-
 tools/perf/util/sort.h                 |    1 +
 tools/perf/util/ui/browser.c           |  176 ++++++++++++++++++++------------
 tools/perf/util/ui/browser.h           |    9 +-
 tools/perf/util/ui/browsers/annotate.c |   17 +--
 tools/perf/util/ui/browsers/hists.c    |   55 +++-------
 tools/perf/util/ui/browsers/map.c      |    6 +-
 tools/perf/util/ui/helpline.h          |    2 +
 12 files changed, 216 insertions(+), 134 deletions(-)


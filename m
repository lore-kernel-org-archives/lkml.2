Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab0D1Bww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:52:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0D1Bwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:52:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Avi Kivity <avi@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Zhang@infradead.org,
       Yanmin <yanmin_zhang@linux.intel.com>
Subject: [GIT PULL] perf tools changes
Date: Tue, 27 Apr 2010 22:52:35 -0300
Message-Id: <1272419560-4332-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
To: Ingo Molnar <mingo@elte.hu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (5):
  perf tools: Rename "kernel_info" to "machine"
  perf machine: Pass buffer size to machine__mmap_name
  perf machine: Adopt some map_groups functions
  perf machines: Make the machines class adopt the dsos__fprintf methods
  perf tools: Create $(OUTPUT)arch/$(ARCH)/util/ directory

 tools/perf/Makefile               |    2 +
 tools/perf/builtin-annotate.c     |    2 +-
 tools/perf/builtin-buildid-list.c |    2 +-
 tools/perf/builtin-kmem.c         |   10 +--
 tools/perf/builtin-record.c       |   36 ++++----
 tools/perf/builtin-report.c       |    2 +-
 tools/perf/builtin-top.c          |   15 ++--
 tools/perf/util/event.c           |   89 +++++++++----------
 tools/perf/util/event.h           |    4 +-
 tools/perf/util/header.c          |   70 +++++++--------
 tools/perf/util/header.h          |    2 +-
 tools/perf/util/map.c             |  121 +++++++++++++------------
 tools/perf/util/map.h             |   71 +++++++--------
 tools/perf/util/probe-event.c     |   20 +++--
 tools/perf/util/session.c         |    9 +-
 tools/perf/util/session.h         |   40 ++++++++-
 tools/perf/util/symbol.c          |  179 +++++++++++++++++--------------------
 tools/perf/util/symbol.h          |   16 ++--
 18 files changed, 348 insertions(+), 342 deletions(-)


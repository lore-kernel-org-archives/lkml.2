Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab0EJQck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:32:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34740 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab0EJQch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:32:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Eric B Munson <ebmunson@us.ibm.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/4] perf improvements and fixes
Date: Mon, 10 May 2010 13:32:17 -0300
Message-Id: <1273509141-15696-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

	The 3rd is important as it fixes a recently introduced bug (yesterday,
I believe), that makes perf record segfault.

Regards,

Arnaldo Carvalho de Melo (4):
  perf newt: Use newtAddComponent()
  perf callchains: Use zalloc to allocate objects
  perf session: create_kernel_maps should use ->host_machine
  perf hist: Introduce hists class and move lots of methods to it

 tools/perf/builtin-annotate.c |   17 ++++----
 tools/perf/builtin-diff.c     |   50 ++++++++++------------
 tools/perf/builtin-report.c   |   71 +++++++++++++++----------------
 tools/perf/builtin-trace.c    |    2 +-
 tools/perf/util/callchain.c   |    6 +-
 tools/perf/util/event.c       |    2 +-
 tools/perf/util/event.h       |   14 ------
 tools/perf/util/hist.c        |   92 ++++++++++++++++++----------------------
 tools/perf/util/hist.h        |   48 ++++++++++++---------
 tools/perf/util/newt.c        |    6 +-
 tools/perf/util/session.c     |    7 +--
 tools/perf/util/session.h     |   12 ++++-
 12 files changed, 154 insertions(+), 173 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab0EIQPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 12:15:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43564 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0EIQPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 12:15:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tom@infradead.org,
       "Zanussi <tzanussi"@gmail.com
Subject: [PATCH 0/3] perf tools minor fixes
Date: Sun,  9 May 2010 13:14:54 -0300
Message-Id: <1273421697-30138-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

Regards,

Arnaldo Carvalho de Melo (3):
  perf callchain: Move validate_callchain to callchain lib
  perf report: Fix leak of resolved callchains array on error path
  perf hist: Simplify the insertion of new hist_entry instances

 tools/perf/builtin-annotate.c |    9 ++-----
 tools/perf/builtin-diff.c     |   14 ++----------
 tools/perf/builtin-report.c   |   43 +++++++++-------------------------------
 tools/perf/util/callchain.c   |    7 ++++++
 tools/perf/util/callchain.h   |    3 ++
 tools/perf/util/hist.c        |   36 +++++++++++++++++++++------------
 tools/perf/util/hist.h        |    5 +---
 7 files changed, 50 insertions(+), 67 deletions(-)


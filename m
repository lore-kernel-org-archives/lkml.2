Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab0HCCJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 22:09:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab0HCCJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 22:09:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 0/3] perf/core fixes and improvements
Date: Mon,  2 Aug 2010 23:09:09 -0300
Message-Id: <1280801352-4630-1-git-send-email-acme@infradead.org>
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

Arnaldo Carvalho de Melo (3):
  perf session: Free the ref_reloc_sym memory at the right place
  perf session: Invalidate last_match when removing threads from rb_tree
  perf tools: Don't keep unreferenced maps when unmaps are detected

 tools/perf/util/hist.c    |    2 +
 tools/perf/util/map.c     |   49 +++++++++++++++++++++++++++++---------------
 tools/perf/util/map.h     |   10 ++++++++-
 tools/perf/util/session.c |    8 +++++++
 tools/perf/util/symbol.c  |   43 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h  |    2 +
 6 files changed, 96 insertions(+), 18 deletions(-)


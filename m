Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab0HTCsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 22:48:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0HTCsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 22:48:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 0/3] perf/core improvements
Date: Thu, 19 Aug 2010 23:47:46 -0300
Message-Id: <1282272469-3675-1-git-send-email-acme@infradead.org>
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
  perf ui browser: Abstract some more slang operations
  perf ui browser: Return the exit key in all browsers
  perf ui browser: Add routines to compactly specify exit keys

 tools/perf/builtin-annotate.c          |   17 ++--
 tools/perf/util/ui/browser.c           |   93 +++++++++++--------
 tools/perf/util/ui/browser.h           |    9 ++-
 tools/perf/util/ui/browsers/annotate.c |   38 ++++----
 tools/perf/util/ui/browsers/hists.c    |  157 ++++++++++++++------------------
 tools/perf/util/ui/browsers/map.c      |   23 ++---
 tools/perf/util/ui/util.c              |    4 +-
 tools/perf/util/util.h                 |   13 ---
 8 files changed, 161 insertions(+), 193 deletions(-)


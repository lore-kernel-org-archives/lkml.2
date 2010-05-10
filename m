Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0EJAUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 20:20:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:46725 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab0EJAUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 20:20:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>,
       "Yanmin, Zhang" <yanmin_zhang@linux.intel.com>
Subject: [GIT PULL v2 0/4] perf tools improvements and minor fixes
Date: Sun,  9 May 2010 21:19:55 -0300
Message-Id: <1273450799-12808-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

Regards,

Arnaldo Carvalho de Melo (4):
  perf symbols: Consider unresolved DSOs in the dso__col_widt calculation
  perf symbols: Check if a struct machine instance was found
  perf session: Embed the host machine data on perf_session
  perf report: Allow limiting the number of entries to print in callchains

 tools/perf/builtin-report.c |    5 ++++-
 tools/perf/util/callchain.h |    1 +
 tools/perf/util/event.c     |   27 +++++++++++++++++++++++++--
 tools/perf/util/hist.c      |   10 ++++++++++
 tools/perf/util/map.c       |   24 ------------------------
 tools/perf/util/session.c   |    8 ++++++++
 tools/perf/util/session.h   |   14 ++++++++------
 tools/perf/util/symbol.c    |    2 +-
 tools/perf/util/symbol.h    |    2 ++
 9 files changed, 59 insertions(+), 34 deletions(-)


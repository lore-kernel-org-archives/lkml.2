Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1BHWKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:10:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:38323 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab1BHWKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:10:01 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/3] perf/core improvements and fixes
Date: Tue,  8 Feb 2011 20:09:07 -0200
Message-Id: <1297202950-15208-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (3):
  perf annotate: Fix --stdio rendering
  perf annotate: Move locking to struct annotation
  perf annotate: Fix annotate context lines regression

 tools/perf/builtin-annotate.c          |   14 ++--
 tools/perf/builtin-report.c            |    5 +-
 tools/perf/builtin-top.c               |   67 ++++++++--------
 tools/perf/util/annotate.c             |  134 +++++++++++++++++++++-----------
 tools/perf/util/annotate.h             |   35 +++++----
 tools/perf/util/hist.c                 |    5 +-
 tools/perf/util/hist.h                 |    3 +-
 tools/perf/util/top.h                  |    6 --
 tools/perf/util/ui/browsers/annotate.c |   18 ++--
 9 files changed, 168 insertions(+), 119 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1BVSxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:53:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:43478 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1BVSxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:53:49 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/2] perf/core TUI live annotate and a cleanup
Date: Tue, 22 Feb 2011 15:53:08 -0300
Message-Id: <1298400790-29453-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

	Mike, if you can give it some stress, I'd appreciate.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (2):
  perf probe: Remove redundant checks
  perf top: Live TUI Annotation

 tools/perf/builtin-top.c               |   36 +++++-----
 tools/perf/util/annotate.h             |    6 +-
 tools/perf/util/probe-event.c          |    2 +-
 tools/perf/util/probe-finder.c         |    5 +-
 tools/perf/util/top.h                  |    1 +
 tools/perf/util/ui/browsers/annotate.c |  126 +++++++++++++++++++++++---------
 tools/perf/util/ui/browsers/top.c      |   45 +++++++++++-
 7 files changed, 159 insertions(+), 62 deletions(-)


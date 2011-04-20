Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab1DTQYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:24:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34983 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab1DTQYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:24:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Witten <mfwitten@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/6] perf/core improvements and fixes
Date: Wed, 20 Apr 2011 13:23:50 -0300
Message-Id: <1303316636-11923-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf symbols: Give more useful names to 'self' parameters

Arun Sharma (1):
  perf script: Add support for PERF_TYPE_RAW

Michael Witten (4):
  perf tools: Makefile: Clean up `python/perf.so' rule
  perf tools: Makefile: PYTHON{,_CONFIG} to bandage Python 3 incompatibility
  perf tools: Move `try-cc'
  perf tools: git mv tools/perf/{features-tests.mak,config/}

 tools/perf/Makefile                 |  107 +++++--
 tools/perf/builtin-script.c         |   14 +-
 tools/perf/config/feature-tests.mak |  128 +++++++
 tools/perf/config/utilities.mak     |  188 +++++++++++
 tools/perf/feature-tests.mak        |  130 -------
 tools/perf/util/symbol.c            |  629 ++++++++++++++++++-----------------
 tools/perf/util/symbol.h            |   78 +++--
 7 files changed, 771 insertions(+), 503 deletions(-)
 create mode 100644 tools/perf/config/feature-tests.mak
 create mode 100644 tools/perf/config/utilities.mak
 delete mode 100644 tools/perf/feature-tests.mak


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1CJTaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:30:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:57589 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab1CJTaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:30:04 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/4] perf/core fixes and improvements
Date: Thu, 10 Mar 2011 16:29:42 -0300
Message-Id: <1299785386-22234-1-git-send-email-acme@infradead.org>
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

Arnaldo Carvalho de Melo (2):
  perf session: Use evlist/evsel for managing perf.data attributes
  perf header: Stop using 'self'

Jiri Olsa (2):
  perf top: Fix events overflow in top command
  perf top: Don't let events to eat up whole header line

 tools/perf/builtin-record.c |  101 ++++-------
 tools/perf/builtin-report.c |    4 +-
 tools/perf/builtin-top.c    |    5 +-
 tools/perf/util/evlist.c    |   26 ++-
 tools/perf/util/evlist.h    |    4 +-
 tools/perf/util/evsel.c     |   21 ++-
 tools/perf/util/evsel.h     |    9 +-
 tools/perf/util/header.c    |  422 +++++++++++++++++++------------------------
 tools/perf/util/header.h    |   48 ++----
 tools/perf/util/session.c   |   74 +-------
 tools/perf/util/session.h   |    2 -
 tools/perf/util/top.c       |   48 ++++--
 12 files changed, 317 insertions(+), 447 deletions(-)


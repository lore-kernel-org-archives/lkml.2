Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0LISNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:13:17 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58490 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab0LISNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:13:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 00/10] perf/core improvements
Date: Thu,  9 Dec 2010 16:12:47 -0200
Message-Id: <1291918376-18261-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf session: Remove unneeded dump_printf calls

David Ahern (1):
  perf report: Allow user to specify path to kallsyms file

Thomas Gleixner (8):
  perf event: Prevent unbound event__name array access
  perf session: Dont queue events w/o timestamps
  perf session: Consolidate the dump code
  perf session: Store file offset in sample_queue
  perf session: Add file_offset to event delivery function
  perf session: Move dump code to event delivery path
  perf session: Split out sample preprocessing
  perf session: Split out user event processing

 tools/perf/Documentation/perf-report.txt |    3 +
 tools/perf/builtin-report.c              |    2 +
 tools/perf/util/event.c                  |   12 ++-
 tools/perf/util/event.h                  |    3 +-
 tools/perf/util/hist.c                   |    9 +-
 tools/perf/util/session.c                |  154 ++++++++++++++++++-----------
 tools/perf/util/symbol.c                 |    9 ++-
 tools/perf/util/symbol.h                 |    1 +
 8 files changed, 127 insertions(+), 66 deletions(-)


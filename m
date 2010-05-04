Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab0EDOAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:00:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab0EDOAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:00:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/3] perf fixes (inject, report, record)
Date: Tue,  4 May 2010 11:00:04 -0300
Message-Id: <1272981607-28723-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

Regards,

- Arnaldo

Anton Blanchard (1):
  perf: Fix performance issue with perf report

Arnaldo Carvalho de Melo (1):
  perf inject: Add missing bits

Tom Zanussi (1):
  perf: record TRACE_INFO only if using tracepoints and SAMPLE_RAW

 tools/perf/Documentation/perf-buildid-cache.txt |    4 +-
 tools/perf/Documentation/perf-inject.txt        |   35 +++++++++++++++++++++++
 tools/perf/builtin-inject.c                     |    2 +-
 tools/perf/builtin-record.c                     |   35 +++++++++++++---------
 tools/perf/command-list.txt                     |    1 +
 tools/perf/util/event.c                         |    1 +
 tools/perf/util/header.c                        |    9 +++++-
 tools/perf/util/parse-events.h                  |    1 +
 tools/perf/util/trace-event-info.c              |    5 +++
 9 files changed, 75 insertions(+), 18 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-inject.txt


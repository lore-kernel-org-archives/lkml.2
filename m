Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1LBQUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:20:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:32817 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab1LBQTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:19:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/4] perf test improvements
Date: Fri,  2 Dec 2011 14:19:25 -0200
Message-Id: <1322842769-7232-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

	Now there are 29 outstanding changesets on this branch.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (4):
  perf evlist: Always do automatic allocation of pollfd and mmap structures
  perf test: Allow running just a subset of the available tests
  perf event: Introduce perf_event__fprintf
  perf test: Validate PERF_RECORD_ events and perf_sample fields

 tools/perf/Documentation/perf-test.txt |    8 +-
 tools/perf/builtin-record.c            |    6 -
 tools/perf/builtin-stat.c              |    3 +-
 tools/perf/builtin-test.c              |  418 ++++++++++++++++++++++++++++++--
 tools/perf/builtin-top.c               |   19 +--
 tools/perf/util/event.c                |   54 ++++-
 tools/perf/util/event.h                |    6 +
 tools/perf/util/evlist.c               |    4 +-
 tools/perf/util/evlist.h               |    2 -
 9 files changed, 465 insertions(+), 55 deletions(-)

-- 
1.7.8.rc0.35.gee6df


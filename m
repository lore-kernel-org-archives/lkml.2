Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab1HPOmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:42:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:34141 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab1HPOly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:41:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, acme@ghostprotocols.net
Subject: [GIT PULL 0/6] perf/core fixes and improvements
Date: Tue, 16 Aug 2011 11:41:29 -0300
Message-Id: <1313505695-20724-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core

Regards,

- Arnaldo

Stephane Eranian (6):
  perf list: Fix exit value
  perf evlist: Fix missing event name init for default event (v2)
  perf tools: Fix error handling of unknown events
  perf annotate: Make output more readable
  perf annotate: Add --symfs option
  perf stat: Add -o and --append options

 tools/perf/Documentation/perf-annotate.txt |   11 ++
 tools/perf/Documentation/perf-stat.txt     |    7 ++
 tools/perf/builtin-annotate.c              |    6 +
 tools/perf/builtin-stat.c                  |  155 ++++++++++++++++-----------
 tools/perf/util/annotate.c                 |    5 +-
 tools/perf/util/color.c                    |    2 +-
 tools/perf/util/evlist.c                   |   11 ++-
 tools/perf/util/parse-events.c             |    8 +-
 tools/perf/util/symbol.c                   |    2 +
 tools/perf/util/symbol.h                   |    4 +-
 10 files changed, 141 insertions(+), 70 deletions(-)


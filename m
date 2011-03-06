Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1CFUtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 15:49:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:39842 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab1CFUsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 15:48:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, William Cohen <wcohen@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/6] perf/core tui fixes and improvements
Date: Sun,  6 Mar 2011 17:48:21 -0300
Message-Id: <1299444507-26549-1-git-send-email-acme@infradead.org>
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

Arnaldo Carvalho de Melo (6):
  perf report tui: Fix multi event switching
  perf hists: Remove needless global col lenght calcs
  perf hists browser: Handle browsing empty hists tree
  perf evlist: Split perf_evlist__id_hash
  perf tools: Improve support for sessions with multiple events
  perf report tui: Improve multi event session support

 tools/perf/builtin-annotate.c       |   80 +++++++++++----
 tools/perf/builtin-report.c         |  161 +++++++++---------------------
 tools/perf/util/event.c             |   57 +-----------
 tools/perf/util/evlist.c            |   28 ++++--
 tools/perf/util/evlist.h            |    3 +
 tools/perf/util/evsel.h             |    2 +
 tools/perf/util/header.c            |   31 ------
 tools/perf/util/header.h            |    2 -
 tools/perf/util/hist.c              |   15 +++-
 tools/perf/util/hist.h              |   22 +---
 tools/perf/util/session.c           |   63 ++++++++++++-
 tools/perf/util/session.h           |   16 +--
 tools/perf/util/symbol.c            |    1 -
 tools/perf/util/symbol.h            |    1 -
 tools/perf/util/ui/browsers/hists.c |  188 +++++++++++++++++++++++++++++-----
 15 files changed, 383 insertions(+), 287 deletions(-)


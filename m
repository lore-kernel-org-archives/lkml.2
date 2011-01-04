Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1ADRSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:18:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:44077 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab1ADRSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:18:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/3] perf/core improvements and fixes
Date: Tue,  4 Jan 2011 15:18:02 -0200
Message-Id: <1294161485-28528-1-git-send-email-acme@infradead.org>
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
  perf test: Clarify some error reports in the open syscall test
  perf evsel: Support perf_evsel__open(cpus > 1 && threads > 1)

Stephane Eranian (1):
  perf tools: Fix perf_event.h header usage

 tools/perf/builtin-test.c      |  124 +++++++++++++++++++++++++++++++++++++--
 tools/perf/util/evsel.c        |   75 +++++++++++++-----------
 tools/perf/util/evsel.h        |    2 +-
 tools/perf/util/parse-events.h |    2 +-
 4 files changed, 159 insertions(+), 44 deletions(-)


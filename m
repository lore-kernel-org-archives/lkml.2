Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab1HRQvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:51:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:38376 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab1HRQvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:51:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Geunsik Lim <geunsik.lim@samsung.com>, Ingo Molnar <mingo@elte.hu>,
        Joe Perches <joe@perches.com>, Josh Boyer <jwboyer@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/6] perf/urgent fixes
Date: Thu, 18 Aug 2011 13:49:58 -0300
Message-Id: <1313686204-30295-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/urgent

	The group event stuff is a fix, as all that was missing was to expose
the "group" bool variable thru a command line option.

Regards,

- Arnaldo

Geunsik Lim (1):
  MAINTAINERS: Fix list of perf events source files

Josh Boyer (1):
  perf tools: Fix build against newer glibc

Lin Ming (1):
  perf tools: Add group event scheduling option to perf record/stat

Stephane Eranian (3):
  perf list: Fix exit value
  perf evlist: Fix missing event name init for default event
  perf tools: Fix error handling of unknown events

 MAINTAINERS                              |    2 +-
 tools/perf/builtin-record.c              |    4 +++-
 tools/perf/builtin-stat.c                |    7 +++++--
 tools/perf/util/evlist.c                 |   11 ++++++++++-
 tools/perf/util/include/linux/compiler.h |    2 ++
 tools/perf/util/parse-events.c           |    8 +++++---
 6 files changed, 26 insertions(+), 8 deletions(-)


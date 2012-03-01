Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2CAR0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:26:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:60907 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab2CARZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:25:59 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL 0/4] perf/urgent fixes
Date: Thu,  1 Mar 2012 14:25:24 -0300
Message-Id: <1330622728-12759-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 30ce2f7eef095d1b8d070740f1948629814fe3c7:

  perf/hwbp: Fix a possible memory leak (2012-02-28 09:52:54 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf-urgent-for-mingo

for you to fetch changes up to 1c1bc9223387dacc48eb2b61b0baabe7e9cf47f6:

  perf probe: Ensure offset provided is not greater than function length without DWARF info too (2012-02-29 18:29:46 -0300)

----------------------------------------------------------------
perf/urgent fixes.

----------------------------------------------------------------
David Ahern (1):
      perf tools: Ensure comm string is properly terminated

Namhyung Kim (1):
      perf evlist: Return first evsel for non-sample event on old kernel

Prashanth Nageshappa (2):
      perf probe: Ensure offset provided is not greater than function length
      perf probe: Ensure offset provided is not greater than function length without DWARF info too

 tools/perf/util/event.c        |    1 +
 tools/perf/util/evlist.c       |    4 ++++
 tools/perf/util/probe-event.c  |    6 ++++++
 tools/perf/util/probe-finder.c |   12 +++++++++++-
 4 files changed, 22 insertions(+), 1 deletions(-)

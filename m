Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935281Ab0HFBrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:47:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33557 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935246Ab0HFBq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:46:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Julia Lawall <julia@diku.dk>, Masami Hiramatsu <mhiramat@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@suse.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 00/10] perf/core improvements and fixes
Date: Thu,  5 Aug 2010 22:46:07 -0300
Message-Id: <1281059177-18747-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Andrea Gelmini (2):
  perf probe: Remove duplicated #include
  perf trace: Clean up #includes

Arnaldo Carvalho de Melo (7):
  perf symbols: Store the symbol binding
  perf ui: Add a map browser
  perf ui: Shorten ui_browser->refresh_entries to refresh
  perf hists: Handle verbose in hists__sort_list_width
  perf hists: Fixup addr snprintf width on 32 bit arches
  perf ui: Add search by name/addr to the map__browser
  perf report: Speed up exit path

Julia Lawall (1):
  perf timechart: Adjust confusing if indentation

 tools/perf/builtin-report.c    |   31 +++++-
 tools/perf/builtin-timechart.c |    4 +-
 tools/perf/builtin-trace.c     |   19 +--
 tools/perf/util/hist.c         |    3 +
 tools/perf/util/newt.c         |  242 +++++++++++++++++++++++++++++++++++++--
 tools/perf/util/probe-finder.c |    1 -
 tools/perf/util/sort.c         |    6 +-
 tools/perf/util/symbol.c       |   30 ++++--
 tools/perf/util/symbol.h       |    1 +
 9 files changed, 297 insertions(+), 40 deletions(-)


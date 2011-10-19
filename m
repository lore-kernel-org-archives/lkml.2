Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab1JSSYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:24:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42632 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1JSSXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:23:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, arnaldo.melo@gmail.com
Subject: [GIT PULL 0/7] perf/core fixes and improvements
Date: Wed, 19 Oct 2011 16:23:31 -0200
Message-Id: <1319048618-9790-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://github.com/acmel/linux.git perf/core

	I noticed problems with the filtering by dso/thread code that I'm still
investigating, as well as working suggestions made since the last pull req.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (3):
  perf hists: Move the dso and thread filters from hist_browser
  perf hists browser: Apply the dso and thread filters when merging new batches
  perf annotate browser: Don't change selection line when returning from callq

David Ahern (4):
  perf script: Fix unknown feature comment
  perf tools: Add prelink suggestion to dso update message
  perf tools: handle endianness of feature bitmap
  perf hists browser: Do not exit on tab key with single event

 tools/perf/util/header.c               |   57 +++++++++++++++++++++++++------
 tools/perf/util/hist.c                 |   57 +++++++++++++++++++++++++++-----
 tools/perf/util/hist.h                 |    9 ++++-
 tools/perf/util/map.c                  |    4 +-
 tools/perf/util/ui/browsers/annotate.c |    2 +-
 tools/perf/util/ui/browsers/hists.c    |   50 +++++++++++++--------------
 6 files changed, 128 insertions(+), 51 deletions(-)


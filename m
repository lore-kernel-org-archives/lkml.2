Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab1CARFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:05:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:49681 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877Ab1CARED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:04:03 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/6] perf/core top tui fixes and improvements
Date: Tue,  1 Mar 2011 14:03:41 -0300
Message-Id: <1298999027-30673-1-git-send-email-acme@infradead.org>
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
  perf top browser: Fix up exit keys
  perf ui browser: Introduce ui_browser__show_title
  perf top browser: Handle empty active symbols list
  perf tui: Make ui__warning modal
  perf top: Fix reporting of invalid --vmlinux
  perf top tui: Wait till the first sample to refresh the screen.

 tools/perf/builtin-top.c          |   26 ++++++++++++++++++++++----
 tools/perf/util/top.h             |    1 +
 tools/perf/util/ui/browser.c      |   18 +++++++++++++++---
 tools/perf/util/ui/browser.h      |    3 ++-
 tools/perf/util/ui/browsers/top.c |   13 +++++++++++++
 tools/perf/util/ui/util.c         |    7 +++++--
 6 files changed, 58 insertions(+), 10 deletions(-)


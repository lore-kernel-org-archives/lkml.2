Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab1DFLAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:00:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51864 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab1DFLAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:00:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        2nddept-manager@sdl.hitachi.co.jp,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/5] perf/urgent fixes
Date: Wed,  6 Apr 2011 08:00:18 -0300
Message-Id: <1302087623-14724-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo


Masami Hiramatsu (5):
  perf probe: Fix to ensure function declared file
  perf probe: Fix to remove redundant close
  perf probe: Fix multiple --vars options behavior
  perf probe: Fix to find recursively inlined function
  perf probe: Fix listing incorrect line number with inline function

 tools/perf/util/probe-event.c  |   19 ++---
 tools/perf/util/probe-finder.c |  159 ++++++++++++++++++++++++++--------------
 2 files changed, 113 insertions(+), 65 deletions(-)


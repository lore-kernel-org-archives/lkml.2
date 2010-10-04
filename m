Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab0JDSzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:55:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:37854 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab0JDSzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:55:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Bernd Petrovitsch <bernd@sysprog.at>,
        "David S . Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
        Ingo Molnar <mingo@elte.hu>, Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>
Subject: [GIT PULL 0/3] perf/urgent fixes
Date: Mon,  4 Oct 2010 15:54:40 -0300
Message-Id: <1286218483-7219-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Frederik Deweerdt (1):
  perf ui hist browser: Fix segfault on 'a' for annotate

Kusanagi Kouichi (1):
  perf tools: Fix build breakage

Stephane Eranian (1):
  perf trace scripting: Fix extern struct definitions

 tools/perf/Makefile                     |    2 +-
 tools/perf/util/trace-event-scripting.c |    4 ++--
 tools/perf/util/ui/browsers/hists.c     |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)


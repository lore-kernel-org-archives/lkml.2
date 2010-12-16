Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0LPMAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:00:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:55726 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab0LPMAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:00:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        2nddept-manager@sdl.hitachi.co.jp,
        Francis Moreau <francis.moro@gmail.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>,
        Franck Bui-Huu <vagabon.xyz@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/4] perf/urgent fixes
Date: Thu, 16 Dec 2010 10:00:13 -0200
Message-Id: <1292500817-1348-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf buildid-list: Fix error return for success

Franck Bui-Huu (3):
  perf probe: Fix use of kernel image path given by 'k' option
  perf symbols: Stop using vmlinux files with no symbols
  perf buildid-cache: Fix symbolic link handling

 tools/perf/builtin-buildid-list.c |    3 +--
 tools/perf/builtin-probe.c        |    5 +++++
 tools/perf/util/header.c          |   10 ++++++----
 tools/perf/util/probe-event.c     |   15 ++++++++++++---
 tools/perf/util/symbol.c          |    4 ++--
 tools/perf/util/symbol.h          |    2 ++
 6 files changed, 28 insertions(+), 11 deletions(-)


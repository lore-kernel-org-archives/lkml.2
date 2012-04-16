Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2DPU32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:29:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34246 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab2DPU3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:29:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Otavio Salvador <otavio@ossystems.com.br>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Mon, 16 Apr 2012 17:29:05 -0300
Message-Id: <1334608147-30588-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

	Please consider pulling,

Thanks,

- Arnaldo

The following changes since commit 7ea6411f4ceb62e5e53170d59d10996dca20c599:

  Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2012-04-15 08:02:36 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 6ffd7bdbf8516d691974d21098278af65d4817a5:

  perf tools: Drop CROSS_COMPILE from flex and bison calls (2012-04-16 16:10:22 -0300)

----------------------------------------------------------------
Fixes for perf/urgent

. No need to use $CROSS_COMPILE for bison and flex, fix from Otavio Salvador

. Fix crash when kernel_map is NULL in perf report, that happened in pipe
  mode, code made more robust by David Ahern.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
David Ahern (1):
      perf report: Fix crash showing warning related to kernel maps

Otavio Salvador (1):
      perf tools: Drop CROSS_COMPILE from flex and bison calls

 tools/perf/Makefile         |    4 ++--
 tools/perf/builtin-report.c |   17 ++++++++++++-----
 2 files changed, 14 insertions(+), 7 deletions(-)

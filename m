Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0HPRKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:10:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:48725 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0HPRKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:10:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL 0/1] perf/urgent TUI annotate fix
Date: Mon, 16 Aug 2010 14:10:30 -0300
Message-Id: <1281978631-15200-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <infradead.org>

Hi Ingo,

	I extracted a fix from the three patch perf/core series I sent,
will rework the other, non critical patches on a new perf/core branch.

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf annotate tui: Fix exit and RIGHT keys handling

 tools/perf/util/ui/browsers/annotate.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


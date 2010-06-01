Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0FAMR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:17:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab0FAMRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:17:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Pierre Tardy <tardyp@gmail.com>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Tue,  1 Jun 2010 09:17:26 -0300
Message-Id: <1275394648-13234-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
Signed-off-by: Konstantin Stepanyuk <konstantin.stepanyuk@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

Regards,

- Arnaldo

Konstantin Stepanyuk (1):
  perf hist: fix objdump output parsing

Pierre Tardy (1):
  perf scripts python: Give field dict to unhandled callback

 tools/perf/scripts/python/check-perf-trace.py      |    3 +-
 tools/perf/util/hist.c                             |    2 +-
 .../util/scripting-engines/trace-event-python.c    |   50 +++++++++++++------
 3 files changed, 36 insertions(+), 19 deletions(-)


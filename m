Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380Ab0FQUhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:37:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342Ab0FQUhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:37:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/2] perf/urgent fixes for 2.6.35
Date: Thu, 17 Jun 2010 17:36:51 -0300
Message-Id: <1276807013-21626-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
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

Arnaldo Carvalho de Melo (1):
  perf session: Remove threads from tree on PERF_RECORD_EXIT

Ian Munsie (1):
  perf record: prevent kill(0, SIGTERM);

 tools/perf/builtin-record.c |    2 +-
 tools/perf/util/event.c     |    4 +++-
 tools/perf/util/session.c   |   11 +++++++++++
 tools/perf/util/session.h   |    2 ++
 tools/perf/util/thread.h    |    5 ++++-
 5 files changed, 21 insertions(+), 3 deletions(-)


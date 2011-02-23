Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab1BWNgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:36:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54240 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab1BWNgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:36:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 0/2] perf/core fixes
Date: Wed, 23 Feb 2011 10:36:25 -0300
Message-Id: <1298468187-6096-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

	Mike, this fixes a segfault when navigating in the tail of the active
list in perf top --tui.

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (1):
  perf top browser: Adjust the browser indexes when refreshing

Marcin Slusarz (1):
  perf lock: Document valid sort keys

 tools/perf/Documentation/perf-lock.txt |   12 ++++++++++--
 tools/perf/builtin-lock.c              |    2 +-
 tools/perf/util/ui/browsers/top.c      |   23 +++++++++++++++++++++++
 3 files changed, 34 insertions(+), 3 deletions(-)


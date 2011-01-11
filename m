Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab1AKTvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:51:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:52669 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687Ab1AKTvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:51:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Kirill Smelkov <kirr@mns.spb.ru>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Renninger <trenn@suse.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/3] perf/urgent fixes
Date: Tue, 11 Jan 2011 17:50:35 -0200
Message-Id: <1294775438-14324-1-git-send-email-acme@infradead.org>
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

Arnaldo Carvalho de Melo (3):
  perf evsel: Fix order of event list deletion
  perf top: Fix annotate segv
  Revert "perf tools: Emit clearer message for sys_perf_event_open ENOENT return"

 tools/perf/builtin-record.c |    4 +---
 tools/perf/builtin-stat.c   |    1 +
 tools/perf/builtin-top.c    |    5 +++--
 tools/perf/perf.c           |    2 --
 4 files changed, 5 insertions(+), 7 deletions(-)


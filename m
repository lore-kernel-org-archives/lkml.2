Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab1AMOLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:11:37 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54106 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab1AMOL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:11:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Kirill Smelkov <kirr@mns.spb.ru>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL 0/2] perf/urgent fixes and an disabled by default improvement
Date: Thu, 13 Jan 2011 12:11:14 -0200
Message-Id: <1294927876-23553-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent

	The 'nodelay' mode for perf record is disabled by default and allows
potentially many 'perf script' usecases that need to receive events as they
happen, with no latency.

Regards,

- Arnaldo

Kirill Smelkov (1):
  perf record: Add "nodelay" mode, disabled by default

Stephane Eranian (1):
  perf sched: Fix list of events, dropping unsupported ':r' modifier

 tools/perf/Documentation/perf-record.txt |    3 +++
 tools/perf/builtin-record.c              |    8 ++++++++
 tools/perf/builtin-sched.c               |   18 +++++++++---------
 3 files changed, 20 insertions(+), 9 deletions(-)


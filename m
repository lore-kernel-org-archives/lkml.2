Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab2KEPt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:49:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab2KEPtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:49:55 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] perf tests: Fixies for perf_event_attr tests
Date: Mon,  5 Nov 2012 16:49:35 +0100
Message-Id: <1352130579-13451-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this patches address comments and some other small fixies.
It's based on current Arnaldo's perf/core.

Attached patches:
  1/4 perf tests: Add attr stat basic test
  2/4 perf tests: Factor attr tests WRITE_ASS macro
  3/4 perf tests: Fix attr watermark field name typo
  4/4 perf tests: Removing 'optional' field

Also available here:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
perf/test7

thanks,
jirka

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr.c               | 87 +++++++++++++++++++++++++++++++++++++++++++--------------------------------------------
 tools/perf/tests/attr.py              | 31 +++++++++++++++++++------------
 tools/perf/tests/attr/base-record     |  2 +-
 tools/perf/tests/attr/base-stat       | 40 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/attr/test-stat-basic |  6 ++++++
 5 files changed, 109 insertions(+), 57 deletions(-)

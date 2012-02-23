Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2BWI13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:27:29 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65009 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2BWI11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:27:27 -0500
X-AuditID: 9c93016f-b7cc4ae0000027c5-cb-4f45f86d9287
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] perf annotate: Random tiny cleanups
Date: Thu, 23 Feb 2012 17:46:19 +0900
Message-Id: <1329986784-4916-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a patchset tries to fix and improve what I found during code reading.
Please take a look and consider applying. Comments are welcome, of course.

Thanks.


Namhyung Kim (5):
  perf annotate: Print asm code as blue when source code is displayed
  perf annotate: Handle lower case key code in annotate_browser__run()
  perf annotate: Restore title when came back to original symbol
  perf annotate: Fix help string on tui
  perf annotate: Add missing newline on error message

 tools/perf/util/annotate.c             |    2 +-
 tools/perf/util/ui/browsers/annotate.c |   18 ++++++++++++------
 2 files changed, 13 insertions(+), 7 deletions(-)

-- 
1.7.9


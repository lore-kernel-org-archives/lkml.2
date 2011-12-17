Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab1LQNgP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 08:36:15 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47475 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194Ab1LQNfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 08:35:46 -0500
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 1/2] tools/perf: const.h to perf-tar-src-pkg
Date: Sat, 17 Dec 2011 14:35:37 +0100
Message-Id: <1324128938-17553-1-git-send-email-sebastian@breakpoint.cc>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoids:
|make: *** No rule to make target `../../include/linux/const.h', needed by `builtin-annotate.o'.  Stop.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 tools/perf/MANIFEST |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index c12659d..1078c5f 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -1,4 +1,5 @@
 tools/perf
+include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
 include/linux/list.h
-- 
1.7.7.3


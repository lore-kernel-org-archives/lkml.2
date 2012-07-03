Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2GCOio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:38:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44695 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2GCOin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:38:43 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: Update scheduler file pattern
Date: Tue,  3 Jul 2012 23:37:31 +0900
Message-Id: <1341326251-4140-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 391e43da797a ("sched: Move all scheduler bits into kernel/sched/")
moved all scheduler codes to the kernel/sched/ directory, but missed the
MAINTAINERS. Since it still expects files from kernel/ directory, get_maintainer
script has to rely on the git (log) fallback mechanism.

 $ scripts/get_maintainer.pl -f kernel/sched/core.c --nogit-fallback
 linux-kernel@vger.kernel.org (open list)

With this patch:

 $ scripts/get_maintainer.pl -f kernel/sched/core.c --nogit-fallback
 Ingo Molnar <mingo@redhat.com> (maintainer:SCHEDULER)
 Peter Zijlstra <peterz@infradead.org> (maintainer:SCHEDULER)
 linux-kernel@vger.kernel.org (open list)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 13a9d455cf24..b950cfde3db1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5917,7 +5917,7 @@ M:	Ingo Molnar <mingo@redhat.com>
 M:	Peter Zijlstra <peterz@infradead.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
 S:	Maintained
-F:	kernel/sched*
+F:	kernel/sched/
 F:	include/linux/sched.h
 
 SCORE ARCHITECTURE
-- 
1.7.9.2


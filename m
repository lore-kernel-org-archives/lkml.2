Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab2LKVve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:51:34 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:38402 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab2LKVuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:50:25 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 16/19] MAINTAINERS: remove arch/*/lib/perf_event*.c
Date: Tue, 11 Dec 2012 19:49:58 -0200
Message-Id: <1355262601-4263-17-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pattern only matched arch/frv/lib/perf_event.c, which was removed
by commit e360adb (irq_work: Add generic hardirq context callbacks).

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index eb0cc18..670db8e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5682,7 +5682,6 @@ F:	arch/*/kernel/perf_event*.c
 F:	arch/*/kernel/*/perf_event*.c
 F:	arch/*/kernel/*/*/perf_event*.c
 F:	arch/*/include/asm/perf_event.h
-F:	arch/*/lib/perf_event*.c
 F:	arch/*/kernel/perf_callchain.c
 F:	tools/perf/
 
-- 
1.7.11.7


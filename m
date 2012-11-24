Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab2KXA16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:27:58 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:53420 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab2KXA1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:54 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 19/24] MAINTAINERS: remove arch/*/lib/perf_event*.c
Date: Fri, 23 Nov 2012 22:26:43 -0200
Message-Id: <1353716808-16375-20-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
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
index cac8e49..3a3a57a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5679,7 +5679,6 @@ F:	arch/*/kernel/perf_event*.c
 F:	arch/*/kernel/*/perf_event*.c
 F:	arch/*/kernel/*/*/perf_event*.c
 F:	arch/*/include/asm/perf_event.h
-F:	arch/*/lib/perf_event*.c
 F:	arch/*/kernel/perf_callchain.c
 F:	tools/perf/
 
-- 
1.7.11.7


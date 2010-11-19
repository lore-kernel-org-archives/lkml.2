Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab0KSV34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:29:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:45776 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0KSV3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:29:55 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf tools: Change my maintainer address
Date: Fri, 19 Nov 2010 19:29:45 -0200
Message-Id: <1290202186-25352-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1290202186-25352-1-git-send-email-acme@infradead.org>
References: <1290202186-25352-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Also remove old snail mail address from CREDITS, moved years ago.

LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 CREDITS     |    2 --
 MAINTAINERS |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/CREDITS b/CREDITS
index 41d8e63..494b6e4 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2365,8 +2365,6 @@ E: acme@redhat.com
 W: http://oops.ghostprotocols.net:81/blog/
 P: 1024D/9224DF01 D5DF E3BB E3C8 BCBB F8AD  841A B6AB 4681 9224 DF01
 D: IPX, LLC, DCCP, cyc2x, wl3501_cs, net/ hacks
-S: R. Brasílio Itiberê, 4270/1010 - Água Verde
-S: 80240-060 - Curitiba - Paraná
 S: Brazil
 
 N: Karsten Merker
diff --git a/MAINTAINERS b/MAINTAINERS
index 8e6548d..f94cd37 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4602,7 +4602,7 @@ PERFORMANCE EVENTS SUBSYSTEM
 M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@elte.hu>
-M:	Arnaldo Carvalho de Melo <acme@redhat.com>
+M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 S:	Supported
 F:	kernel/perf_event*.c
 F:	include/linux/perf_event.h
-- 
1.6.2.5


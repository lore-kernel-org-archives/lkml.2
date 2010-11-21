Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0KUNnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 08:43:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:60554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab0KUNnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 08:43:40 -0500
Date: Sun, 21 Nov 2010 13:43:24 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Change my maintainer address
Message-ID: <tip-4aafd3f71a257a3522932944b5204262dfdff147@git.kernel.org>
Git-Commit-ID: 4aafd3f71a257a3522932944b5204262dfdff147
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 21 Nov 2010 13:43:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4aafd3f71a257a3522932944b5204262dfdff147
Gitweb:     http://git.kernel.org/tip/4aafd3f71a257a3522932944b5204262dfdff147
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 19 Nov 2010 16:46:26 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 19 Nov 2010 16:46:26 -0200

perf tools: Change my maintainer address

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

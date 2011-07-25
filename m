Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab1GYUHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:07:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:59909 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab1GYUHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:07:16 -0400
Date: Mon, 25 Jul 2011 20:06:51 GMT
From: tip-bot for Jesper Juhl <jj@chaosbits.net>
Message-ID: <tip-f629299b544b6cc12b4e3e85fec96f4ce5809482@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        rostedt@goodmis.org, jj@chaosbits.net, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        a.p.zijlstra@chello.nl, jj@chaosbits.net, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <alpine.LNX.2.00.1107250929370.8080@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107250929370.8080@swampdragon.chaosbits.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] trace events: Update version number reference to new 3.x scheme for EVENT_POWER_TRACING_DEPRECATED
Git-Commit-ID: f629299b544b6cc12b4e3e85fec96f4ce5809482
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 25 Jul 2011 20:06:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f629299b544b6cc12b4e3e85fec96f4ce5809482
Gitweb:     http://git.kernel.org/tip/f629299b544b6cc12b4e3e85fec96f4ce5809482
Author:     Jesper Juhl <jj@chaosbits.net>
AuthorDate: Sun, 24 Jul 2011 23:15:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 Jul 2011 09:37:21 +0200

trace events: Update version number reference to new 3.x scheme for EVENT_POWER_TRACING_DEPRECATED

What was scheduled to be 2.6.41 is now going to be 3.1 .

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1107250929370.8080@swampdragon.chaosbits.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 2ad39e5..cd31345 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -82,7 +82,7 @@ config EVENT_POWER_TRACING_DEPRECATED
 	  power:power_frequency
 	  This is for userspace compatibility
 	  and will vanish after 5 kernel iterations,
-	  namely 2.6.41.
+	  namely 3.1.
 
 config CONTEXT_SWITCH_TRACER
 	bool

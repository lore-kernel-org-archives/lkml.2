Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1GXVPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 17:15:46 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27522 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1GXVPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 17:15:45 -0400
Date: Sun, 24 Jul 2011 23:15:42 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH][Trivial] Update version number reference to new 3.x scheme
 for EVENT_POWER_TRACING_DEPRECATED
Message-ID: <alpine.LNX.2.00.1107242313550.7103@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What was scheduled to be 2.6.41 is now going to be 3.1 .

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


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


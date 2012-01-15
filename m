Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab2AOUsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 15:48:40 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23959 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2AOUsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 15:48:39 -0500
Date: Sun, 15 Jan 2012 21:48:38 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH][Trivial] Fix up version number reference in
 include/trace/events/power.h
Message-ID: <alpine.LNX.2.00.1201152146570.13389@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What was originally going to be 2.6.41 became 3.1 .

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 include/trace/events/power.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 1bcc2a8..b262699 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -65,7 +65,7 @@ TRACE_EVENT(machine_suspend,
 	TP_printk("state=%lu", (unsigned long)__entry->state)
 );
 
-/* This code will be removed after deprecation time exceeded (2.6.41) */
+/* This code will be removed after deprecation time exceeded (3.1) */
 #ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
 
 /*
-- 
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


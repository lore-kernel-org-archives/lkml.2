Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab2KSFmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:42:23 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44794 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2KSF3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:04 -0500
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 06/58] trace: Mark tracing_dentry_percpu static
Date: Sun, 18 Nov 2012 21:27:45 -0800
Message-Id: <1353302917-13995-7-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of kernel/trace/trace.c references tracing_dentry_percpu.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 31e4f55..032f9ee 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4461,7 +4461,7 @@ struct dentry *tracing_init_dentry(void)
 
 static struct dentry *d_percpu;
 
-struct dentry *tracing_dentry_percpu(void)
+static struct dentry *tracing_dentry_percpu(void)
 {
 	static int once;
 	struct dentry *d_tracer;
-- 
1.7.10.4


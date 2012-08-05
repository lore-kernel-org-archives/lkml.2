Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab2HEIb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 04:31:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36805 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab2HEIbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 04:31:43 -0400
From: eshink@gmail.com
To: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alex Kelly <eshink@gmail.com>, Alex Kelly <alex.page.kelly@gmail.com>
Subject: [PATCH 3/4] fs: Clean up some artifacts in coredump.c
Date: Sun,  5 Aug 2012 01:28:19 -0700
Message-Id: <1344155300-10432-3-git-send-email-eshink@gmail.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1344155300-10432-1-git-send-email-eshink@gmail.com>
References: <1344027800-8270-1-git-send-email-eshink@gmail.com>
 <1344155300-10432-1-git-send-email-eshink@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Kelly <eshink@gmail.com>

Specifically, some whitespace got carried over from the move that
shouldn't have, and there were some comment style issues in the original
code that are now fixed

Signed-off-by: Alex Kelly <alex.page.kelly@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/coredump.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 34c9236..7f75060 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -70,7 +70,6 @@ static int zap_process(struct task_struct *start, int exit_code)
 	return nr;
 }
 
-
 /*
  * Core dumping helper functions.  These are the only things you should
  * do on a core-file: use only these functions to write out all the
@@ -195,8 +194,10 @@ static int format_corename(struct core_name *cn, long signr)
 	if (!cn->corename)
 		return -ENOMEM;
 
-	/* Repeat as long as we have more pattern to process and more output
-	   space */
+	/*
+	 * Repeat as long as we have more pattern to process and more output
+	 * space.
+	 */
 	while (*pat_ptr) {
 		if (*pat_ptr != '%') {
 			if (*pat_ptr == 0)
@@ -471,7 +472,6 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 	return 0;
 }
 
-
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
-- 
1.7.11.2


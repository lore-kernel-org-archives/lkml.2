Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab2HQChd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:37:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37989 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab2HQCh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:37:28 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 1/2] dyndbg: spelling fix in comment
Date: Thu, 16 Aug 2012 20:37:22 -0600
Message-Id: <1345171043-14859-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.10.1.487.ga3935e6
In-Reply-To: <1345171043-14859-1-git-send-email-jim.cromie@gmail.com>
References: <1345171043-14859-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a comment referring to <debugfs>/dynamic_debug/conrol.
It should be control.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 7ca29a0..86d4065 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -630,7 +630,7 @@ static __init int ddebug_setup_query(char *str)
 __setup("ddebug_query=", ddebug_setup_query);
 
 /*
- * File_ops->write method for <debugfs>/dynamic_debug/conrol.  Gathers the
+ * File_ops->write method for <debugfs>/dynamic_debug/control.  Gathers the
  * command text from userspace, parses and executes it.
  */
 #define USER_BUF_PAGE 4096
-- 
1.7.10.1.487.ga3935e6


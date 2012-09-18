Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2IRXhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 19:37:19 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33643 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2IRXhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 19:37:13 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 2/6] dyndbg: spelling fix s/conrol/control/
Date: Tue, 18 Sep 2012 17:36:43 -0600
Message-Id: <1348011407-24108-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
References: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix name of control file in comment

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index ceda053..43ae319 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -680,7 +680,7 @@ static __init int ddebug_setup_query(char *str)
 __setup("ddebug_query=", ddebug_setup_query);
 
 /*
- * File_ops->write method for <debugfs>/dynamic_debug/conrol.  Gathers the
+ * File_ops->write method for <debugfs>/dynamic_debug/control.  Gathers the
  * command text from userspace, parses and executes it.
  */
 #define USER_BUF_PAGE 4096
-- 
1.7.11.4


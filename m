Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965776Ab2FBT2K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 15:28:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59451 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965702Ab2FBT2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 15:28:08 -0400
From: Matthew Shaw <shaw500@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Matthew Shaw <shaw500@gmail.com>
Subject: [PATCH] init: main: Corrected some coding style issues.
Date: Sat,  2 Jun 2012 20:27:20 +0100
Message-Id: <1338665240-14751-1-git-send-email-shaw500@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Signed-off-by: Matthew Shaw <shaw500@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/init/main.c b/init/main.c
index 1ca6b32..66125f0 100644
--- a/init/main.c
+++ b/init/main.c
@@ -6,7 +6,7 @@
  *  GK 2/5/95  -  Changed to support mounting root fs via NFS
  *  Added initrd & change_root: Werner Almesberger & Hans Lermen, Feb '96
  *  Moan early if gcc is old, avoiding bogus kernels - Paul Gortmaker, May '96
- *  Simplified starting of init:  Michael A. Griffith <grif@acm.org> 
+ *  Simplified starting of init:  Michael A. Griffith <grif@acm.org>
  */
 
 #include <linux/types.h>
@@ -148,8 +148,8 @@ static int __init set_reset_devices(char *str)
 
 __setup("reset_devices", set_reset_devices);
 
-static const char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
-const char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
+static const char *argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
+const char *envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
 static const char *panic_later, *panic_param;
 
 extern const struct obs_kernel_param __setup_start[], __setup_end[];
@@ -464,7 +464,7 @@ static void __init mm_init(void)
 
 asmlinkage void __init start_kernel(void)
 {
-	char * command_line;
+	char *command_line;
 	extern const struct kernel_param __start___param[], __stop___param[];
 
 	/*
@@ -838,7 +838,7 @@ static noinline int init_post(void)
 	      "See Linux Documentation/init.txt for guidance.");
 }
 
-static int __init kernel_init(void * unused)
+static int __init kernel_init(void *unused)
 {
 	/*
 	 * Wait until kthreadd is all set-up.
-- 
1.7.9.5


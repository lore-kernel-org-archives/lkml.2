Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1FGKkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:40:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44697 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1FGKkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:40:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=akshayjoshi.com; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=S3yv4SVTq3twaz7iGzzyk05J0Otb20EUtaNPqvCBAl8xyANN7KxcHBIXM/AtJEJf/z
         2vMf5QWhvS+uL93WJTf+wPWNM1tAGDD28wO8Hc4fDZfZeET/8FXNGxPvLYF0IwU38nJY
         sKTaPGtfnoQ9FaPYO27MiRWor4xeBVe7yQDMI=
From: Akshay Joshi <me@akshayjoshi.com>
Cc: Akshay Joshi <me@akshayjoshi.com>, Jiri Slaby <jslaby@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] Kernel: fix spaces with respect to the coding style in sys.c.
Date: Tue,  7 Jun 2011 06:39:39 -0400
Message-Id: <1307443181-22278-6-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307443181-22278-2-git-send-email-me@akshayjoshi.com>
References: <1307443181-22278-2-git-send-email-me@akshayjoshi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed trailing spaces, spaces around the ternary operators and in the
pre-processor function declarations with the help of the checkpatch.pl
tool.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 kernel/sys.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index e4128b2..94f02f5 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -51,28 +51,28 @@
 #include <asm/unistd.h>
 
 #ifndef SET_UNALIGN_CTL
-# define SET_UNALIGN_CTL(a,b)	(-EINVAL)
+# define SET_UNALIGN_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef GET_UNALIGN_CTL
-# define GET_UNALIGN_CTL(a,b)	(-EINVAL)
+# define GET_UNALIGN_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef SET_FPEMU_CTL
-# define SET_FPEMU_CTL(a,b)	(-EINVAL)
+# define SET_FPEMU_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef GET_FPEMU_CTL
-# define GET_FPEMU_CTL(a,b)	(-EINVAL)
+# define GET_FPEMU_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef SET_FPEXC_CTL
-# define SET_FPEXC_CTL(a,b)	(-EINVAL)
+# define SET_FPEXC_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef GET_FPEXC_CTL
-# define GET_FPEXC_CTL(a,b)	(-EINVAL)
+# define GET_FPEXC_CTL(a, b)	(-EINVAL)
 #endif
 #ifndef GET_ENDIAN
-# define GET_ENDIAN(a,b)	(-EINVAL)
+# define GET_ENDIAN(a, b)	(-EINVAL)
 #endif
 #ifndef SET_ENDIAN
-# define SET_ENDIAN(a,b)	(-EINVAL)
+# define SET_ENDIAN(a, b)	(-EINVAL)
 #endif
 #ifndef GET_TSC_CTL
 # define GET_TSC_CTL(a)		(-EINVAL)
@@ -342,7 +342,7 @@ EXPORT_SYMBOL_GPL(kernel_restart);
 static void kernel_shutdown_prepare(enum system_states state)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list,
-		(state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
+		(state == SYSTEM_HALT) ? SYS_HALT : SYS_POWER_OFF, NULL);
 	system_state = state;
 	usermodehelper_disable();
 	device_shutdown();
@@ -488,7 +488,7 @@ void ctrl_alt_del(void)
 	else
 		kill_cad_pid(SIGINT, 1);
 }
-	
+
 /*
  * Unprivileged users may change the real gid to the effective gid
  * or vice versa.  (BSD-style)
@@ -502,7 +502,7 @@ void ctrl_alt_del(void)
  *
  * The general idea is that a program which uses just setregid() will be
  * 100% compatible with BSD.  A program which uses just setgid() will be
- * 100% compatible with POSIX with saved IDs. 
+ * 100% compatible with POSIX with saved IDs.
  *
  * SMP: There are not races, the GIDs are checked only by filesystem
  *      operations (as far as semantic preservation is concerned).
@@ -550,7 +550,7 @@ error:
 }
 
 /*
- * setgid() is implemented like SysV w/ SAVED_IDS 
+ * setgid() is implemented like SysV w/ SAVED_IDS
  *
  * SMP: Same implicit races as above.
  */
@@ -615,7 +615,7 @@ static int set_user(struct cred *new)
  *
  * The general idea is that a program which uses just setreuid() will be
  * 100% compatible with BSD.  A program which uses just setuid() will be
- * 100% compatible with POSIX with saved IDs. 
+ * 100% compatible with POSIX with saved IDs.
  */
 SYSCALL_DEFINE2(setreuid, uid_t, ruid, uid_t, euid)
 {
@@ -666,17 +666,17 @@ error:
 	abort_creds(new);
 	return retval;
 }
-		
+
 /*
- * setuid() is implemented like SysV with SAVED_IDS 
- * 
+ * setuid() is implemented like SysV with SAVED_IDS
+ *
  * Note that SAVED_ID's is deficient in that a setuid root program
- * like sendmail, for example, cannot set its uid to be a normal 
+ * like sendmail, for example, cannot set its uid to be a normal
  * user and then switch back, because if you're root, setuid() sets
  * the saved uid too.  If you don't like this, blame the bright people
  * in the POSIX committee and/or USG.  Note that the BSD-style setreuid()
  * will allow a root program to temporarily drop privileges and be able to
- * regain them by swapping the real and effective uid.  
+ * regain them by swapping the real and effective uid.
  */
 SYSCALL_DEFINE1(setuid, uid_t, uid)
 {
@@ -1282,7 +1282,7 @@ SYSCALL_DEFINE2(getrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 /*
  *	Back compatibility for getrlimit. Needed for some apps.
  */
- 
+
 SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 		struct rlimit __user *, rlim)
 {
@@ -1297,7 +1297,7 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 		x.rlim_cur = 0x7FFFFFFF;
 	if (x.rlim_max > 0x7FFFFFFF)
 		x.rlim_max = 0x7FFFFFFF;
-	return copy_to_user(rlim, &x, sizeof(x))?-EFAULT:0;
+	return copy_to_user(rlim, &x, sizeof(x)) ? -EFAULT : 0;
 }
 
 #endif
-- 
1.7.4.4


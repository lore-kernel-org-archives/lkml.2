Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1FGKks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:40:48 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:52229 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab1FGKkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=akshayjoshi.com; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LBgyEzf0d93/MFXsnX5e7ER9Fvk6Cde0WzT0IWWmYs5DSO5FqaljVYVZym4NrHU47T
         xQ2SEGZPe0fB/AkMO9JlDrwCykThHT7kSScfLTzOIAuMe9eLYnHGQvwLAn0ftXIdzzjn
         Nb1+Ry8qVhgvAWNMRe9M0cP8wW+1s3jcTpZ7s=
From: Akshay Joshi <me@akshayjoshi.com>
Cc: Akshay Joshi <me@akshayjoshi.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] Kernel: style fixes to spaces for sysctl.c.
Date: Tue,  7 Jun 2011 06:39:40 -0400
Message-Id: <1307443181-22278-7-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307443181-22278-2-git-send-email-me@akshayjoshi.com>
References: <1307443181-22278-2-git-send-email-me@akshayjoshi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed various things to fit the code style of the kernel, including
removing trailing whitespace, removing spaces between function calls and
their arguments and adding spaces between function arguments in function
definitions.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 kernel/sysctl.c |   96 +++++++++++++++++++++++++++---------------------------
 1 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4fc9244..2bf9080 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -469,14 +469,14 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "stop-a",
 		.data		= &stop_a_enabled,
-		.maxlen		= sizeof (int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "scons-poweroff",
 		.data		= &scons_pwroff,
-		.maxlen		= sizeof (int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
@@ -485,7 +485,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "tsb-ratio",
 		.data		= &sysctl_tsb_ratio,
-		.maxlen		= sizeof (int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
@@ -494,14 +494,14 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "soft-power",
 		.data		= &pwrsw_enabled,
-		.maxlen		= sizeof (int),
-	 	.mode		= 0644,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "unaligned-trap",
 		.data		= &unaligned_enabled,
-		.maxlen		= sizeof (int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
@@ -572,7 +572,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "sg-big-buff",
 		.data		= &sg_big_buff,
-		.maxlen		= sizeof (int),
+		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
@@ -590,7 +590,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "sysrq",
 		.data		= &__sysrq_enabled,
-		.maxlen		= sizeof (int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= sysrq_sysctl_handler,
 	},
@@ -599,7 +599,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "cad_pid",
 		.data		= NULL,
-		.maxlen		= sizeof (int),
+		.maxlen		= sizeof(int),
 		.mode		= 0600,
 		.proc_handler	= proc_do_cad_pid,
 	},
@@ -660,7 +660,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "pid_max",
 		.data		= &pid_max,
-		.maxlen		= sizeof (int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &pid_max_min,
@@ -726,7 +726,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,
-		.maxlen		= sizeof (int),
+		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
@@ -734,7 +734,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname       = "watchdog",
 		.data           = &watchdog_enabled,
-		.maxlen         = sizeof (int),
+		.maxlen         = sizeof(int),
 		.mode           = 0644,
 		.proc_handler   = proc_dowatchdog,
 		.extra1		= &zero,
@@ -761,7 +761,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname       = "nmi_watchdog",
 		.data           = &watchdog_enabled,
-		.maxlen         = sizeof (int),
+		.maxlen         = sizeof(int),
 		.mode           = 0644,
 		.proc_handler   = proc_dowatchdog,
 		.extra1		= &zero,
@@ -772,7 +772,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname       = "unknown_nmi_panic",
 		.data           = &unknown_nmi_panic,
-		.maxlen         = sizeof (int),
+		.maxlen         = sizeof(int),
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec,
 	},
@@ -795,14 +795,14 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "bootloader_type",
 		.data		= &bootloader_type,
-		.maxlen		= sizeof (int),
+		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "bootloader_version",
 		.data		= &bootloader_version,
-		.maxlen		= sizeof (int),
+		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
 	},
@@ -834,7 +834,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "spin_retry",
 		.data		= &spin_retry,
-		.maxlen		= sizeof (int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
@@ -843,7 +843,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "acpi_video_flags",
 		.data		= &acpi_realmode_flags,
-		.maxlen		= sizeof (unsigned long),
+		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
 	},
@@ -852,14 +852,14 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "ignore-unaligned-usertrap",
 		.data		= &no_unaligned_warning,
-		.maxlen		= sizeof (int),
-	 	.mode		= 0644,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "unaligned-dump-stack",
 		.data		= &unaligned_dump_stack,
-		.maxlen		= sizeof (int),
+		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
@@ -900,8 +900,8 @@ static struct ctl_table kern_table[] = {
 	{
 		.procname	= "compat-log",
 		.data		= &compat_log,
-		.maxlen		= sizeof (int),
-	 	.mode		= 0644,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 #endif
@@ -1022,7 +1022,7 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname	= "page-cluster", 
+		.procname	= "page-cluster",
 		.data		= &page_cluster,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
@@ -1468,7 +1468,7 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0555,
 		.child		= inotify_table,
 	},
-#endif	
+#endif
 #ifdef CONFIG_EPOLL
 	{
 		.procname	= "epoll",
@@ -1829,7 +1829,7 @@ static void try_attach(struct ctl_table_header *p, struct ctl_table_header *q)
  * cover common cases -
  *
  * proc_dostring(), proc_dointvec(), proc_dointvec_jiffies(),
- * proc_dointvec_userhz_jiffies(), proc_dointvec_minmax(), 
+ * proc_dointvec_userhz_jiffies(), proc_dointvec_minmax(),
  * proc_doulongvec_ms_jiffies_minmax(), proc_doulongvec_minmax()
  *
  * It is the handler's job to read the input buffer from user memory
@@ -2055,7 +2055,7 @@ static int _proc_do_string(void* data, int maxlen, int write,
 		}
 		if (len >= maxlen)
 			len = maxlen-1;
-		if(copy_from_user(data, buffer, len))
+		if (copy_from_user(data, buffer, len))
 			return -EFAULT;
 		((char *) data)[len] = 0;
 		*ppos += *lenp;
@@ -2075,10 +2075,10 @@ static int _proc_do_string(void* data, int maxlen, int write,
 		if (len > *lenp)
 			len = *lenp;
 		if (len)
-			if(copy_to_user(buffer, data, len))
+			if (copy_to_user(buffer, data, len))
 				return -EFAULT;
 		if (len < *lenp) {
-			if(put_user('\n', ((char __user *) buffer) + len))
+			if (put_user('\n', ((char __user *) buffer) + len))
 				return -EFAULT;
 			len++;
 		}
@@ -2269,12 +2269,12 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 	unsigned long page = 0;
 	size_t left;
 	char *kbuf;
-	
+
 	if (!tbl_data || !table->maxlen || !*lenp || (*ppos && !write)) {
 		*lenp = 0;
 		return 0;
 	}
-	
+
 	i = (int *) tbl_data;
 	vleft = table->maxlen / sizeof(*i);
 	left = *lenp;
@@ -2296,7 +2296,7 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 		kbuf[left] = 0;
 	}
 
-	for (; left && vleft--; i++, first=0) {
+	for (; left && vleft--; i++, first = 0) {
 		unsigned long lval;
 		bool neg;
 
@@ -2363,15 +2363,14 @@ static int do_proc_dointvec(struct ctl_table *table, int write,
  * @ppos: file position
  *
  * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
- * values from/to the user buffer, treated as an ASCII string. 
+ * values from/to the user buffer, treated as an ASCII string.
  *
  * Returns 0 on success.
  */
 int proc_dointvec(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-    return do_proc_dointvec(table,write,buffer,lenp,ppos,
-		    	    NULL,NULL);
+	return do_proc_dointvec(table, write, buffer, lenp, ppos, NULL, NULL);
 }
 
 /*
@@ -2585,7 +2584,8 @@ static int do_proc_doulongvec_minmax(struct ctl_table *table, int write,
 int proc_doulongvec_minmax(struct ctl_table *table, int write,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-    return do_proc_doulongvec_minmax(table, write, buffer, lenp, ppos, 1l, 1l);
+	return do_proc_doulongvec_minmax(table, write, buffer, lenp, ppos,
+			1l, 1l);
 }
 
 /**
@@ -2609,7 +2609,7 @@ int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
 				      void __user *buffer,
 				      size_t *lenp, loff_t *ppos)
 {
-    return do_proc_doulongvec_minmax(table, write, buffer,
+	return do_proc_doulongvec_minmax(table, write, buffer,
 				     lenp, ppos, HZ, 1000l);
 }
 
@@ -2690,7 +2690,7 @@ static int do_proc_dointvec_ms_jiffies_conv(bool *negp, unsigned long *lvalp,
  * @ppos: file position
  *
  * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
- * values from/to the user buffer, treated as an ASCII string. 
+ * values from/to the user buffer, treated as an ASCII string.
  * The values read are assumed to be in seconds, and are converted into
  * jiffies.
  *
@@ -2699,8 +2699,8 @@ static int do_proc_dointvec_ms_jiffies_conv(bool *negp, unsigned long *lvalp,
 int proc_dointvec_jiffies(struct ctl_table *table, int write,
 			  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-    return do_proc_dointvec(table,write,buffer,lenp,ppos,
-		    	    do_proc_dointvec_jiffies_conv,NULL);
+	return do_proc_dointvec(table, write, buffer, lenp, ppos,
+		do_proc_dointvec_jiffies_conv, NULL);
 }
 
 /**
@@ -2712,8 +2712,8 @@ int proc_dointvec_jiffies(struct ctl_table *table, int write,
  * @ppos: pointer to the file position
  *
  * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
- * values from/to the user buffer, treated as an ASCII string. 
- * The values read are assumed to be in 1/USER_HZ seconds, and 
+ * values from/to the user buffer, treated as an ASCII string.
+ * The values read are assumed to be in 1/USER_HZ seconds, and
  * are converted into jiffies.
  *
  * Returns 0 on success.
@@ -2721,8 +2721,8 @@ int proc_dointvec_jiffies(struct ctl_table *table, int write,
 int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-    return do_proc_dointvec(table,write,buffer,lenp,ppos,
-		    	    do_proc_dointvec_userhz_jiffies_conv,NULL);
+	return do_proc_dointvec(table, write, buffer, lenp, ppos,
+			do_proc_dointvec_userhz_jiffies_conv, NULL);
 }
 
 /**
@@ -2735,8 +2735,8 @@ int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write,
  * @ppos: the current position in the file
  *
  * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
- * values from/to the user buffer, treated as an ASCII string. 
- * The values read are assumed to be in 1/1000 seconds, and 
+ * values from/to the user buffer, treated as an ASCII string.
+ * The values read are assumed to be in 1/1000 seconds, and
  * are converted into jiffies.
  *
  * Returns 0 on success.
@@ -2817,7 +2817,7 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 		if (copy_from_user(kbuf, buffer, left)) {
 			free_page(page);
 			return -EFAULT;
-                }
+		}
 		kbuf[left] = 0;
 
 		tmp_bitmap = kzalloc(BITS_TO_LONGS(bitmap_len) * sizeof(unsigned long),
@@ -2969,7 +2969,7 @@ int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
 				      void __user *buffer,
 				      size_t *lenp, loff_t *ppos)
 {
-    return -ENOSYS;
+	return -ENOSYS;
 }
 
 
-- 
1.7.4.4


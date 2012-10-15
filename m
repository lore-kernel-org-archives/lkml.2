Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2JOKdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 06:33:41 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61663 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab2JOKdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 06:33:38 -0400
From: Chad Williamson <chad@dahc.us>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Cotey <puff65537@bansheeslibrary.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chad Williamson <chad@dahc.us>
Subject: [PATCH 4/5] staging: silicom: remove unnecessary braces in bp_proc.c
Date: Mon, 15 Oct 2012 05:30:38 -0500
Message-Id: <1350297039-8166-5-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350297039-8166-1-git-send-email-chad@dahc.us>
References: <1350297039-8166-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary braces from single statement blocks in bp_proc.c,
resolving checkpatch.pl warnings.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bp_proc.c | 58 +++++++++++++--------------------------
 1 file changed, 19 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/silicom/bp_proc.c b/drivers/staging/silicom/bp_proc.c
index aa084ef..0f110aa 100644
--- a/drivers/staging/silicom/bp_proc.c
+++ b/drivers/staging/silicom/bp_proc.c
@@ -86,9 +86,8 @@ static struct proc_dir_entry *proc_getdir(char *name,
 	if (pde == (struct proc_dir_entry *)0) {
 		/* create the directory */
 		pde = create_proc_entry(name, S_IFDIR, proc_dir);
-		if (pde == (struct proc_dir_entry *)0) {
+		if (pde == (struct proc_dir_entry *)0)
 			return pde;
-		}
 	}
 	return pde;
 }
@@ -107,10 +106,8 @@ bypass_proc_create_entry_sd(struct pfs_unit *pfs_unit_curr,
 						      S_IFREG | S_IRUSR |
 						      S_IWUSR | S_IRGRP |
 						      S_IROTH, parent_pfs);
-	if (pfs_unit_curr->proc_entry == 0) {
-
+	if (pfs_unit_curr->proc_entry == 0)
 		return -1;
-	}
 
 	pfs_unit_curr->proc_entry->read_proc = read_proc;
 	pfs_unit_curr->proc_entry->write_proc = write_proc;
@@ -207,9 +204,8 @@ set_bypass_pfs(struct file *file, const char *buffer,
 	if (count > (sizeof(kbuf) - 1))
 		return -1;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -239,9 +235,8 @@ set_tap_pfs(struct file *file, const char *buffer,
 	if (count > (sizeof(kbuf) - 1))
 		return -1;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -271,9 +266,8 @@ set_disc_pfs(struct file *file, const char *buffer,
 	if (count > (sizeof(kbuf) - 1))
 		return -1;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -421,9 +415,8 @@ set_bypass_wd_pfs(struct file *file, const char *buffer,
 	unsigned int timeout = 0;
 	char *timeout_ptr = kbuf;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	timeout_ptr = kbuf;
 	timeout = atoi(&timeout_ptr);
@@ -570,9 +563,8 @@ set_dis_bypass_pfs(struct file *file, const char *buffer,
 
 	int bypass_param = 0, length = 0;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -599,9 +591,8 @@ set_dis_tap_pfs(struct file *file, const char *buffer,
 
 	int tap_param = 0, length = 0;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -628,9 +619,8 @@ set_dis_disc_pfs(struct file *file, const char *buffer,
 
 	int tap_param = 0, length = 0;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -717,9 +707,8 @@ set_bypass_pwup_pfs(struct file *file, const char *buffer,
 
 	int bypass_param = 0, length = 0;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -746,9 +735,8 @@ set_bypass_pwoff_pfs(struct file *file, const char *buffer,
 
 	int bypass_param = 0, length = 0;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -775,9 +763,8 @@ set_tap_pwup_pfs(struct file *file, const char *buffer,
 
 	int tap_param = 0, length = 0;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -804,9 +791,8 @@ set_disc_pwup_pfs(struct file *file, const char *buffer,
 
 	int tap_param = 0, length = 0;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -913,9 +899,8 @@ set_std_nic_pfs(struct file *file, const char *buffer,
 
 	int bypass_param = 0, length = 0;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -988,9 +973,8 @@ set_wd_exp_mode_pfs(struct file *file, const char *buffer,
 	if (count > (sizeof(kbuf) - 1))
 		return -1;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -1036,9 +1020,8 @@ set_wd_autoreset_pfs(struct file *file, const char *buffer,
 	u32 timeout = 0;
 	char *timeout_ptr = kbuf;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	timeout_ptr = kbuf;
 	timeout = atoi(&timeout_ptr);
@@ -1061,9 +1044,8 @@ set_tpl_pfs(struct file *file, const char *buffer,
 	if (count > (sizeof(kbuf) - 1))
 		return -1;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -1094,9 +1076,8 @@ set_wait_at_pwup_pfs(struct file *file, const char *buffer,
 	if (count > (sizeof(kbuf) - 1))
 		return -1;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
@@ -1126,9 +1107,8 @@ set_hw_reset_pfs(struct file *file, const char *buffer,
 	if (count > (sizeof(kbuf) - 1))
 		return -1;
 
-	if (copy_from_user(&kbuf, buffer, count)) {
+	if (copy_from_user(&kbuf, buffer, count))
 		return -1;
-	}
 
 	kbuf[count] = '\0';
 	length = strlen(kbuf);
-- 
1.7.12.2


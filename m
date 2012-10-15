Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab2JOKcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 06:32:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57364 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2JOKcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 06:32:51 -0400
From: Chad Williamson <chad@dahc.us>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Cotey <puff65537@bansheeslibrary.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chad Williamson <chad@dahc.us>
Subject: [PATCH 1/5] staging: silicom: fix whitespace in bp_proc.c
Date: Mon, 15 Oct 2012 05:30:35 -0500
Message-Id: <1350297039-8166-2-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350297039-8166-1-git-send-email-chad@dahc.us>
References: <1350297039-8166-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove superfluous spaces in bp_proc.c to resolve checkpatch.pl errors.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bp_proc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/silicom/bp_proc.c b/drivers/staging/silicom/bp_proc.c
index 6ad4b27..f7b4699 100644
--- a/drivers/staging/silicom/bp_proc.c
+++ b/drivers/staging/silicom/bp_proc.c
@@ -11,7 +11,7 @@
 /******************************************************************************/
 
 #include <linux/version.h>
-#if defined(CONFIG_SMP) && ! defined(__SMP__)
+#if defined(CONFIG_SMP) && !defined(__SMP__)
 #define __SMP__
 #endif
 
@@ -24,7 +24,7 @@
 #define BP_PROC_DIR "bypass"
 //#define BYPASS_SUPPORT "bypass"
 
-#ifdef  BYPASS_SUPPORT
+#ifdef BYPASS_SUPPORT
 
 #define GPIO6_SET_ENTRY_SD           "gpio6_set"
 #define GPIO6_CLEAR_ENTRY_SD         "gpio6_clear"
@@ -98,8 +98,8 @@ static struct proc_dir_entry *proc_getdir(char *name,
 int
 bypass_proc_create_entry_sd(struct pfs_unit *pfs_unit_curr,
 			    char *proc_name,
-			    write_proc_t * write_proc,
-			    read_proc_t * read_proc,
+			    write_proc_t *write_proc,
+			    read_proc_t *read_proc,
 			    struct proc_dir_entry *parent_pfs, void *data)
 {
 	strcpy(pfs_unit_curr->proc_name, proc_name);
@@ -1147,7 +1147,7 @@ set_hw_reset_pfs(struct file *file, const char *buffer,
 
 #endif				/*PMC_FIX_FLAG */
 
-int bypass_proc_create_dev_sd(bpctl_dev_t * pbp_device_block)
+int bypass_proc_create_dev_sd(bpctl_dev_t *pbp_device_block)
 {
 	struct bypass_pfs_sd *current_pfs = &(pbp_device_block->bypass_pfs_set);
 	static struct proc_dir_entry *procfs_dir = NULL;
@@ -1327,7 +1327,7 @@ int bypass_proc_create_dev_sd(bpctl_dev_t * pbp_device_block)
 	return ret;
 }
 
-int bypass_proc_remove_dev_sd(bpctl_dev_t * pbp_device_block)
+int bypass_proc_remove_dev_sd(bpctl_dev_t *pbp_device_block)
 {
 
 	struct bypass_pfs_sd *current_pfs = &pbp_device_block->bypass_pfs_set;
-- 
1.7.12.2


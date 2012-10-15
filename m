Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab2JOKdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 06:33:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57364 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2JOKdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 06:33:17 -0400
From: Chad Williamson <chad@dahc.us>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Cotey <puff65537@bansheeslibrary.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chad Williamson <chad@dahc.us>
Subject: [PATCH 2/5] staging: silicom: fix C99 comments in bp_proc.c
Date: Mon, 15 Oct 2012 05:30:36 -0500
Message-Id: <1350297039-8166-3-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350297039-8166-1-git-send-email-chad@dahc.us>
References: <1350297039-8166-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix C99 // comments in bp_proc.c to resolve checkpatch.pl errors.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bp_proc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/silicom/bp_proc.c b/drivers/staging/silicom/bp_proc.c
index f7b4699..4599cc9 100644
--- a/drivers/staging/silicom/bp_proc.c
+++ b/drivers/staging/silicom/bp_proc.c
@@ -18,11 +18,11 @@
 #include <linux/proc_fs.h>
 #include <linux/netdevice.h>
 #include <asm/uaccess.h>
-//#include <linux/smp_lock.h>
+/* #include <linux/smp_lock.h> */
 #include "bp_mod.h"
 
 #define BP_PROC_DIR "bypass"
-//#define BYPASS_SUPPORT "bypass"
+/* #define BYPASS_SUPPORT "bypass" */
 
 #ifdef BYPASS_SUPPORT
 
@@ -70,7 +70,7 @@
 #define DISC_CHANGE_ENTRY_SD      "disc_change"
 #define DIS_DISC_ENTRY_SD         "dis_disc"
 #define DISC_PWUP_ENTRY_SD        "disc_pwup"
-#endif				//bypass_support
+#endif	/* bypass_support */
 static struct proc_dir_entry *bp_procfs_dir;
 
 static struct proc_dir_entry *proc_getdir(char *name,
-- 
1.7.12.2


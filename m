Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2JOKdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 06:33:31 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61663 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2JOKd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 06:33:29 -0400
From: Chad Williamson <chad@dahc.us>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Cotey <puff65537@bansheeslibrary.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chad Williamson <chad@dahc.us>
Subject: [PATCH 3/5] staging: silicom: remove parentheses from return statements in bg_proc.c
Date: Mon, 15 Oct 2012 05:30:37 -0500
Message-Id: <1350297039-8166-4-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350297039-8166-1-git-send-email-chad@dahc.us>
References: <1350297039-8166-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary parentheses from return statements in bg_proc.c to
resolve checkpatch.pl errors.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bp_proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/silicom/bp_proc.c b/drivers/staging/silicom/bp_proc.c
index 4599cc9..aa084ef 100644
--- a/drivers/staging/silicom/bp_proc.c
+++ b/drivers/staging/silicom/bp_proc.c
@@ -87,10 +87,10 @@ static struct proc_dir_entry *proc_getdir(char *name,
 		/* create the directory */
 		pde = create_proc_entry(name, S_IFDIR, proc_dir);
 		if (pde == (struct proc_dir_entry *)0) {
-			return (pde);
+			return pde;
 		}
 	}
-	return (pde);
+	return pde;
 }
 
 #ifdef BYPASS_SUPPORT
-- 
1.7.12.2


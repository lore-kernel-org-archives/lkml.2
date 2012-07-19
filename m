Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab2GSVKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:10:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41964 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab2GSVKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:10:53 -0400
From: jan.bannister@gmail.com
To: viro@zeniv.linux.org.uk, schwidefsky@de.ibm.com,
        linux-kernel@vger.kernel.org
Cc: Jan Bannister <jan.bannister@gmail.com>
Subject: [PATCH] kernel: acct.c:  spaces required around that '<'
Date: Thu, 19 Jul 2012 22:10:27 +0100
Message-Id: <1342732227-13972-1-git-send-email-jan.bannister@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Bannister <jan.bannister@gmail.com>

Fixed a coding style issue

Signed-off-by: Jan Bannister <jan.bannister@gmail.com>
---
 kernel/acct.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 02e6167..725d3a9 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -134,7 +134,7 @@ static int check_free_space(struct bsd_acct_struct *acct, struct file *file)
 	spin_lock(&acct_lock);
 	if (file != acct->file) {
 		if (act)
-			res = act>0;
+			res = act > 0;
 		goto out;
 	}
 
-- 
1.7.4.4


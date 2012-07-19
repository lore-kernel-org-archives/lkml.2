Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2GSVal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:30:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33804 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2GSVah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:30:37 -0400
From: jan.bannister@gmail.com
To: viro@zeniv.linux.org.uk
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
        Jan Bannister <jan.bannister@gmail.com>
Subject: [PATCH] kernel: acct.c:  spaces required around that '<'
Date: Thu, 19 Jul 2012 22:30:16 +0100
Message-Id: <50087c7a.7449b40a.7ef4.ffffd463@mx.google.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <y>
References: <y>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab0FDMvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 08:51:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38970 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab0FDMvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 08:51:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MKciV/H+IWF/Z+sQcvw3M7t7l3O+7sNCntoLsRQe1EtR2n0g9A89vRcPfucQt7sSgb
         /5ZT5sePzAKTHm5O9VH+3NmGTvQC5hnJvHPPHNlDV8fxjSrXCe9H33NeOogkTmREXxpz
         StqGH5sO1MoJ2ZZwSm10ONcTrhgOzqvV8EI+8=
Subject: [PATCH] Minix: Clean up left over label
From: Andrew Hendry <andrew.hendry@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 22:51:24 +1000
Message-ID: <1275655884.8635.7.camel@jaunty>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove a left over fail label. 

Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index 9196958..1dbf921 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -75,10 +75,6 @@ static struct page * dir_get_page(struct inode *dir, unsigned long n)
 	if (!IS_ERR(page))
 		kmap(page);
 	return page;
-
-fail:
-	dir_put_page(page);
-	return ERR_PTR(-EIO);
 }
 
 static inline void *minix_next_entry(void *de, struct minix_sb_info *sbi)



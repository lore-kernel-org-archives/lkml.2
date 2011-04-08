Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab1DHRdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 13:33:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34540 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab1DHRdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 13:33:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=YFr6MfQsQTyKsLndlnGc0yDgGgLx4XBtLgRdB91CwCnicMGynHCk1R14TqE2uOFqrR
         ZR0ChNSXiqV01ymxGc88EObZeKACmYeQXF5ch3J56Kus6htY+B9Vba5DPN49p9v7Zmx5
         0O8se7M4g3jFz2VTLHMSHwy+Woq4gURCl1t3Q=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Trivial patches <trivial@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] ufs: Fix a typo
Date: Fri,  8 Apr 2011 19:33:07 +0200
Message-Id: <1302283987-22248-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 fs/ufs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 27a4bab..c72b6ce 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -409,7 +409,7 @@ out:
 }
 
 /**
- * ufs_getfrag_bloc() - `get_block_t' function, interface between UFS and
+ * ufs_getfrag_block() - `get_block_t' function, interface between UFS and
  * readpage, writepage and so on
  */
 
-- 
1.7.4.1


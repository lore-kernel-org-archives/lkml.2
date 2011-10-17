Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1JQUWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:22:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53217 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1JQUWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:22:02 -0400
Subject: [PATCH] drivers, vmw_balloon.c: Fix typo in code comment.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, dtor@vmware.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 01:34:23 +0600
Message-ID: <1318880063.10091.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Fix typo in code comment.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 053d36c..2480c21 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -151,7 +151,7 @@ MODULE_LICENSE("GPL");
 struct vmballoon_stats {
 	unsigned int timer;
 
-	/* allocation statustics */
+	/* allocation statistics */
 	unsigned int alloc;
 	unsigned int alloc_fail;
 	unsigned int sleep_alloc;



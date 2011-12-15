Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab1LODXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:23:54 -0500
Received: from ozlabs.org ([203.10.76.45]:51357 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758682Ab1LODXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:23:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
Subject: [PATCH 5/15] sm_ftl: fix module parameter.
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 15 Dec 2011 13:35:49 +1030
Message-ID: <87y5uesfea.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You didn't mean this to be a bool.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/mtd/sm_ftl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/sm_ftl.c b/drivers/mtd/sm_ftl.c
--- a/drivers/mtd/sm_ftl.c
+++ b/drivers/mtd/sm_ftl.c
@@ -25,7 +25,7 @@
 struct workqueue_struct *cache_flush_workqueue;
 
 static int cache_timeout = 1000;
-module_param(cache_timeout, bool, S_IRUGO);
+module_param(cache_timeout, int, S_IRUGO);
 MODULE_PARM_DESC(cache_timeout,
 	"Timeout (in ms) for cache flush (1000 ms default");
 

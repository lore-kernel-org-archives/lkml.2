Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2EHMde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:33:34 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:45015 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab2EHMdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:33:33 -0400
From: zwu.kernel@gmail.com
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, wuzhy@linux.vnet.ibm.com
Subject: [PATCH] block: fix uncorrect file description
Date: Tue,  8 May 2012 20:31:04 +0800
Message-Id: <1336480264-15530-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050812-7408-0000-0000-000004DA3662
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 block/blk-exec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index fb2cbd5..3681c6e 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -1,5 +1,5 @@
 /*
- * Functions related to setting various queue properties from drivers
+ * Functions related to executing a block request
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
-- 
1.7.6


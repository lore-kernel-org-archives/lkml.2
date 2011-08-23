Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab1HWGMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 02:12:30 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:49501 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1HWGM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 02:12:27 -0400
From: Boojin Kim <boojin.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Boojin Kim <boojin.kim@samsung.com>
Subject: [PATCH] DMA: PL330: add missing header
Date: Tue, 23 Aug 2011 14:57:38 +0900
Message-Id: <1314079058-24601-1-git-send-email-boojin.kim@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixup below build error

drivers/dma/pl330.c: In function 'pl330_prep_slave_sg':
drivers/dma/pl330.c:603: error: implicit declaration of function 'for_each_sg'
drivers/dma/pl330.c:603: error: expected ';' before '{' token
drivers/dma/pl330.c:581: warning: unused variable 'flags'
drivers/dma/pl330.c: In function 'pl330_probe':
drivers/dma/pl330.c:720: warning: comparison of distinct pointer types lacks a cast
make[2]: *** [drivers/dma/pl330.o] Error 1

Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
---
 drivers/dma/pl330.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 00eee59..fcad90c 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -17,6 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl330.h>
+#include <linux/scatterlist.h>
 
 #define NR_DEFAULT_DESC	16
 
-- 
1.7.1


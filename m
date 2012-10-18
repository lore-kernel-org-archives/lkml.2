Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2JRB55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:57:57 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:47538 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab2JRB5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:57:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 1/2] drivers: dma-contiguous: Don't redefine SZ_1M
Date: Thu, 18 Oct 2012 03:58:40 +0200
Message-Id: <1350525521-2148-1-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the definition from linux/sizes.h instead.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/base/dma-contiguous.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 9a14694..612afcc 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -27,15 +27,12 @@
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/page-isolation.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/mm_types.h>
 #include <linux/dma-contiguous.h>
 
-#ifndef SZ_1M
-#define SZ_1M (1 << 20)
-#endif
-
 struct cma {
 	unsigned long	base_pfn;
 	unsigned long	count;
-- 
1.7.8.6


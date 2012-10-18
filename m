Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2JRB54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:57:56 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:47539 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab2JRB5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:57:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/2] drivers: dma-coherent: Fix typo in dma_mmap_from_coherent documentation
Date: Thu, 18 Oct 2012 03:58:41 +0200
Message-Id: <1350525521-2148-2-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1350525521-2148-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1350525521-2148-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function documentation incorrectly references dma_release_coherent.
Fix it. Don't mention a specific function name as dma_mmap_from_coherent
as multiple callers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/base/dma-coherent.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/base/dma-coherent.c b/drivers/base/dma-coherent.c
index 560a717..bc256b6 100644
--- a/drivers/base/dma-coherent.c
+++ b/drivers/base/dma-coherent.c
@@ -191,9 +191,8 @@ EXPORT_SYMBOL(dma_release_from_coherent);
  * This checks whether the memory was allocated from the per-device
  * coherent memory pool and if so, maps that memory to the provided vma.
  *
- * Returns 1 if we correctly mapped the memory, or 0 if
- * dma_release_coherent() should proceed with mapping memory from
- * generic pools.
+ * Returns 1 if we correctly mapped the memory, or 0 if the caller should
+ * proceed with mapping memory from generic pools.
  */
 int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
 			   void *vaddr, size_t size, int *ret)
-- 
1.7.8.6


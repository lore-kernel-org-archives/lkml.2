Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab0JHSzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:55:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36381 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab0JHSzp (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 8 Oct 2010 14:55:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] x86/iommu: Update header comments with appropriate naming.
Date: Fri,  8 Oct 2010 14:53:48 -0400
Message-Id: <1286564028-2352-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286564028-2352-1-git-send-email-konrad.wilk@oracle.com>
References: <1286564028-2352-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header comments diverged a bit from the implementation. Lets
re-sync them.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/iommu_table.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
index df55a78..f229b13 100644
--- a/arch/x86/include/asm/iommu_table.h
+++ b/arch/x86/include/asm/iommu_table.h
@@ -1,4 +1,3 @@
-
 #ifndef _ASM_X86_IOMMU_TABLE_H
 #define _ASM_X86_IOMMU_TABLE_H
 
@@ -60,7 +59,7 @@ struct iommu_table_entry {
  * and it will be run after the SWIOTLB and the other IOMMUs
  * that utilize this macro. If the IOMMU is detected (ie, the
  * detect routine returns a positive value), the other IOMMUs
- * are also checked. You can use IOMMU_INIT_FINISH if you prefer
+ * are also checked. You can use IOMMU_INIT_POST_FINISH if you prefer
  * to stop detecting the other IOMMUs after yours has been detected.
  */
 #define IOMMU_INIT_POST(_detect)					\
@@ -80,9 +79,9 @@ struct iommu_table_entry {
  *  d). Similar to the 'init', except that this gets called from pci_iommu_init
  *      where we do have a memory allocator.
  *
- * The _CONT vs the _EXIT differs in that the _CONT variant will
+ * The standard vs the _FINISH differs in that the _FINISH variant will
  * continue detecting other IOMMUs in the call list after the
- * the detection routine returns a positive number. The _EXIT will
+ * the detection routine returns a positive number. The _FINISH will
  * stop the execution chain. Both will still call the 'init' and
  * 'late_init' functions if they are set.
  */
-- 
1.7.0.4


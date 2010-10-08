Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036Ab0JHUNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 16:13:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:48698 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab0JHUNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 16:13:39 -0400
Date: Fri, 8 Oct 2010 20:13:21 GMT
From: tip-bot for Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1286564028-2352-3-git-send-email-konrad.wilk@oracle.com>
References: <1286564028-2352-3-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] x86, iommu: Update header comments with appropriate naming
Message-ID: <tip-6e9636693373d938aa3b13427be3d212f172ac06@git.kernel.org>
Git-Commit-ID: 6e9636693373d938aa3b13427be3d212f172ac06
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 08 Oct 2010 20:13:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e9636693373d938aa3b13427be3d212f172ac06
Gitweb:     http://git.kernel.org/tip/6e9636693373d938aa3b13427be3d212f172ac06
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Fri, 8 Oct 2010 14:53:48 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 8 Oct 2010 13:11:21 -0700

x86, iommu: Update header comments with appropriate naming

The header comments diverged a bit from the implementation. Lets
re-sync them.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference: <1286564028-2352-3-git-send-email-konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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

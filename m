Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab0JHSzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:55:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35591 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab0JHSzC (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 8 Oct 2010 14:55:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Konrad Rzeszutek Wilk <konrad@dumpdata.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] ia64/iommu: Add a dummy iommu_table.h file in IA64.
Date: Fri,  8 Oct 2010 14:53:47 -0400
Message-Id: <1286564028-2352-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286564028-2352-1-git-send-email-konrad.wilk@oracle.com>
References: <1286564028-2352-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad@dumpdata.com>

We don't need a complex IOMMU dependency list on IA64 so
we just define the IOMMU_* macro which is used the DMAR driver, as a dummy.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reported-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/ia64/include/asm/iommu_table.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)
 create mode 100644 arch/ia64/include/asm/iommu_table.h

diff --git a/arch/ia64/include/asm/iommu_table.h b/arch/ia64/include/asm/iommu_table.h
new file mode 100644
index 0000000..92c8d36
--- /dev/null
+++ b/arch/ia64/include/asm/iommu_table.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_IA64_IOMMU_TABLE_H
+#define _ASM_IA64_IOMMU_TABLE_H
+
+#define IOMMU_INIT_POST(_detect)
+
+#endif /* _ASM_IA64_IOMMU_TABLE_H */
-- 
1.7.0.4


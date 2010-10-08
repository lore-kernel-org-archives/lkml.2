Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493Ab0JHUNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 16:13:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:48701 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759249Ab0JHUNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 16:13:41 -0400
Date: Fri, 8 Oct 2010 20:13:00 GMT
From: tip-bot for Konrad Rzeszutek Wilk <konrad@dumpdata.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, konrad@dumpdata.com, tony.luck@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, konrad@dumpdata.com, tglx@linutronix.de,
        tony.luck@intel.com, hpa@linux.intel.com
In-Reply-To: <1286564028-2352-2-git-send-email-konrad.wilk@oracle.com>
References: <1286564028-2352-2-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] ia64, iommu: Add a dummy iommu_table.h file in IA64.
Message-ID: <tip-fc6a2f37d084173de57fe75f73cbe4bb296b9e8a@git.kernel.org>
Git-Commit-ID: fc6a2f37d084173de57fe75f73cbe4bb296b9e8a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 08 Oct 2010 20:13:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc6a2f37d084173de57fe75f73cbe4bb296b9e8a
Gitweb:     http://git.kernel.org/tip/fc6a2f37d084173de57fe75f73cbe4bb296b9e8a
Author:     Konrad Rzeszutek Wilk <konrad@dumpdata.com>
AuthorDate: Fri, 8 Oct 2010 14:53:47 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 8 Oct 2010 13:11:11 -0700

ia64, iommu: Add a dummy iommu_table.h file in IA64.

We don't need a complex IOMMU dependency list on IA64 so
we just define the IOMMU_* macro which is used the DMAR driver, as a dummy.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference: <1286564028-2352-2-git-send-email-konrad.wilk@oracle.com>
Reported-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/ia64/include/asm/iommu_table.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

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

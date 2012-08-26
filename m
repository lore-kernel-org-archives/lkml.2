Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab2HZBvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 21:51:17 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44452 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2HZBvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 21:51:15 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 09:51:15 +0800
Message-ID: <CAPgLHd9NxLd3m_s9KqF5P-n9BACgE2Nj=xCL-+0tkEuG-ZwGnA@mail.gmail.com>
Subject: [PATCH] iommu/amd: remove duplicated include from amd_iommu_init.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: joerg.roedel@amd.com
Cc: yongjun_wei@trendmicro.com.cn, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/iommu/amd_iommu_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 0a2ea31..1292b5a 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -26,7 +26,6 @@
 #include <linux/msi.h>
 #include <linux/amd-iommu.h>
 #include <linux/export.h>
-#include <linux/acpi.h>
 #include <acpi/acpi.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab2JBWP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:15:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39695 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab2JBWPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:15:55 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] iommu: tegra: remove include of <mach/iomap.h>
Date: Tue,  2 Oct 2012 16:15:49 -0600
Message-Id: <1349216149-858-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Nothing from this file is used, and the file will hopefully be deleted
soon.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Joerg, if this patch can get into 3.7 (it's late, I know) then that
would be great. If not, may I please request an ack so I can take the
change through the Tegra tree in 3.8, since I will probably have cleanup
patches that depend on this change. Thanks.

This is based on the IOMMU arm/tegra branch.
---
 drivers/iommu/tegra-smmu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index e1d17fe..e7b56da 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -38,7 +38,6 @@
 #include <asm/page.h>
 #include <asm/cacheflush.h>
 
-#include <mach/iomap.h>
 #include <mach/tegra-ahb.h>
 
 enum smmu_hwgrp {
-- 
1.7.0.4


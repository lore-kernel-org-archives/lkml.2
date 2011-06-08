Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1FHV3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:29:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44616 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1FHV3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:29:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6371"; a="96298744"
From: Laura Abbott <lauraa@codeaurora.org>
To: iommu@lists.linux-foundation.org, Tom Lyon <pugs@cisco.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Cc: Laura Abbott <lauraa@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] iommu-api: Add missing header file
Date: Wed,  8 Jun 2011 14:29:11 -0700
Message-Id: <1307568552-9239-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_IOMMU_API is not defined some functions will just
return -ENODEV. Add errno.h for the definition of ENODEV.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 include/linux/iommu.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 0a2ba40..9940319 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -19,6 +19,8 @@
 #ifndef __LINUX_IOMMU_H
 #define __LINUX_IOMMU_H

+#include <linux/errno.h>
+
 #define IOMMU_READ	(1)
 #define IOMMU_WRITE	(2)
 #define IOMMU_CACHE	(4) /* DMA cache coherency */
--
1.7.3.3


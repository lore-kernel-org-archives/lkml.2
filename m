Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab1KVBMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:12:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890Ab1KVBMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:12:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] device.h: Fix struct member documentation
Date: Mon, 21 Nov 2011 17:11:22 -0800
Message-Id: <1321924284-26414-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <20111122005858.GB25420@kroah.com>
References: <20111122005858.GB25420@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcos Paulo de Souza <marcos.mage@gmail.com>

Fix warning of make xmldocs of documention of the struct member iommu_ops from struct bus_type.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index ffbcf95..2b88320 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -69,7 +69,7 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
  * @resume:	Called to bring a device on this bus out of sleep mode.
  * @pm:		Power management operations of this bus, callback the specific
  *		device driver's pm-ops.
- * @iommu_ops   IOMMU specific operations for this bus, used to attach IOMMU
+ * @iommu_ops:  IOMMU specific operations for this bus, used to attach IOMMU
  *              driver implementations to a bus and allow the driver to do
  *              bus-specific setup
  * @p:		The private data of the driver core, only the driver core can
-- 
1.7.7.3


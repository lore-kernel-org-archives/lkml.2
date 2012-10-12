Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2JLFnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 01:43:50 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42703 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab2JLFnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 01:43:49 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        andriy.shevchenko@linux.intel.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/3] dmaengine: dw_dmac: Update documentation style comments for dw_dma_platform_data
Date: Fri, 12 Oct 2012 11:13:40 +0530
Message-Id: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 12 Oct 2012 05:43:44.0920 (UTC) FILETIME=[8B1F4980:01CDA83C]
X-MC-Unique: 112101206434700901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9C5htHM014279

Documentation style comments were missing for few fields in struct
dw_dma_platform_data. Add these.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/dw_dmac.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index e1c8c9e..62a6190 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -19,6 +19,8 @@
  * @nr_channels: Number of channels supported by hardware (max 8)
  * @is_private: The device channels should be marked as private and not for
  *	by the general purpose DMA channel allocator.
+ * @chan_allocation_order: Allocate channels starting from 0 or 7
+ * @chan_priority: Set channel priority increasing from 0 to 7 or 7 to 0.
  * @block_size: Maximum block size supported by the controller
  * @nr_masters: Number of AHB masters supported by the controller
  * @data_width: Maximum data width supported by hardware per AHB master
-- 
1.7.12.rc2.18.g61b472e



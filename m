Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab2JPETl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:19:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57469 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab2JPETk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:19:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        andriy.shevchenko@linux.intel.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 1/3] dmaengine: dw_dmac: Update documentation style comments for dw_dma_platform_data
Date: Tue, 16 Oct 2012 09:49:16 +0530
Message-Id: <3100e691db3f94c22afd98b609a1568d7e70dfe7.1350360935.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 16 Oct 2012 04:19:36.0022 (UTC) FILETIME=[73659760:01CDAB55]
X-MC-Unique: 112101605193800501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9G4KeWp029511

Documentation style comments were missing for few fields in struct
dw_dma_platform_data. Add these.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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



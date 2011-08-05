Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1HEKD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:03:59 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:34915 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853Ab1HEKDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:03:53 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <alim.akhtar@gmail.com>
Subject: [PATCH V3 05/20] dmaengine/amba-pl08x: Complete doc comment for struct pl08x_txd
Date: Fri, 5 Aug 2011 15:32:30 +0530
Message-ID: <22f3ef37fd399c8424b393c5fb63d51bd0b8c5ce.1312538034.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312538034.git.viresh.kumar@st.com>
References: <cover.1312538034.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doc comment for struct pl08x_txd was incomplete. Complete that.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 include/linux/amba/pl08x.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index e6e28f3..cd8f629 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -105,8 +105,16 @@ struct pl08x_phy_chan {
 
 /**
  * struct pl08x_txd - wrapper for struct dma_async_tx_descriptor
+ * @tx: async tx descriptor
+ * @node: node for txd list for channels
+ * @src_addr: src address of txd
+ * @dst_addr: dst address of txd
+ * @len: transfer len in bytes
+ * @direction: direction of transfer
  * @llis_bus: DMA memory address (physical) start for the LLIs
  * @llis_va: virtual memory address start for the LLIs
+ * @cctl: control reg values for current txd
+ * @ccfg: config reg values for current txd
  */
 struct pl08x_txd {
 	struct dma_async_tx_descriptor tx;
-- 
1.7.2.2


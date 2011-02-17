Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab1BQHZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 02:25:20 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:34083 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028Ab1BQHZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 02:25:17 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>
Cc: <shiraz.hashim@st.com>, <amit.goel@st.com>, <armando.visconti@st.com>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 1/7] dw_dmac: Remove compilation dependency from AVR32
Date: Thu, 17 Feb 2011 12:54:51 +0530
Message-ID: <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1297926678.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be used in SPEAr, ARM family.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 1c28816..95c7db7 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -82,7 +82,6 @@ config INTEL_IOP_ADMA
 
 config DW_DMAC
 	tristate "Synopsys DesignWare AHB DMA support"
-	depends on AVR32
 	select DMA_ENGINE
 	default y if CPU_AT32AP7000
 	help
-- 
1.7.2.2


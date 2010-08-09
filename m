Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab0HIMJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:09:36 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:42806 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756329Ab0HIMJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:09:28 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 14/14] DMAENGINE: ste_dma40: added kernel doc for struct
Date: Mon, 9 Aug 2010 14:09:21 +0200
Message-ID: <1281355761-13671-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

The half-channel struct was undocumented.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 1620492..1127af2 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -91,13 +91,6 @@ enum stedma40_periph_data_width {
 	STEDMA40_DOUBLEWORD_WIDTH = STEDMA40_ESIZE_64_BIT
 };
 
-struct stedma40_half_channel_info {
-	enum stedma40_endianess endianess;
-	enum stedma40_periph_data_width data_width;
-	int psize;
-	enum stedma40_flow_ctrl flow_ctrl;
-};
-
 enum stedma40_xfer_dir {
 	STEDMA40_MEM_TO_MEM = 1,
 	STEDMA40_MEM_TO_PERIPH,
@@ -107,6 +100,21 @@ enum stedma40_xfer_dir {
 
 
 /**
+ * struct stedma40_chan_cfg - dst/src channel configuration
+ *
+ * @endianess: Endianess of the src/dst hardware
+ * @data_width: Data width of the src/dst hardware
+ * @p_size: Burst size
+ * @flow_ctrl: Flow control on/off.
+ */
+struct stedma40_half_channel_info {
+	enum stedma40_endianess endianess;
+	enum stedma40_periph_data_width data_width;
+	int psize;
+	enum stedma40_flow_ctrl flow_ctrl;
+};
+
+/**
  * struct stedma40_chan_cfg - Structure to be filled by client drivers.
  *
  * @dir: MEM 2 MEM, PERIPH 2 MEM , MEM 2 PERIPH, PERIPH 2 PERIPH
-- 
1.6.3.3


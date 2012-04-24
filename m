Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab2DXW7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:59:45 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49931 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab2DXWfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:35:02 -0400
Message-Id: <20120424223243.870183804@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 22/62] mwifiex: update pcie8766 scratch register addresses
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit 428ca8a7065354877db63ceabfc493107686eebe upstream.

The scratch register addresses have been changed for newer chips.
Since the old chip was never shipped and it will not be supported
any more, just update register addresses to support the new chips.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/pcie.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -48,15 +48,15 @@
 #define PCIE_HOST_INT_STATUS_MASK			0xC3C
 #define PCIE_SCRATCH_2_REG				0xC40
 #define PCIE_SCRATCH_3_REG				0xC44
-#define PCIE_SCRATCH_4_REG				0xCC0
-#define PCIE_SCRATCH_5_REG				0xCC4
-#define PCIE_SCRATCH_6_REG				0xCC8
-#define PCIE_SCRATCH_7_REG				0xCCC
-#define PCIE_SCRATCH_8_REG				0xCD0
-#define PCIE_SCRATCH_9_REG				0xCD4
-#define PCIE_SCRATCH_10_REG				0xCD8
-#define PCIE_SCRATCH_11_REG				0xCDC
-#define PCIE_SCRATCH_12_REG				0xCE0
+#define PCIE_SCRATCH_4_REG				0xCD0
+#define PCIE_SCRATCH_5_REG				0xCD4
+#define PCIE_SCRATCH_6_REG				0xCD8
+#define PCIE_SCRATCH_7_REG				0xCDC
+#define PCIE_SCRATCH_8_REG				0xCE0
+#define PCIE_SCRATCH_9_REG				0xCE4
+#define PCIE_SCRATCH_10_REG				0xCE8
+#define PCIE_SCRATCH_11_REG				0xCEC
+#define PCIE_SCRATCH_12_REG				0xCF0
 
 #define CPU_INTR_DNLD_RDY				BIT(0)
 #define CPU_INTR_DOOR_BELL				BIT(1)



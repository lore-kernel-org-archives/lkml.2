Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1EIHKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:10:54 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:5069 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab1EIHKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:10:17 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH V3 6/6] pch_dma: modify pci device table definition
Date: Mon,  9 May 2011 16:09:40 +0900
Message-Id: <1304924980-3433-6-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1304924980-3433-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1304924980-3433-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/dma/pch_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
index 9c98739..b321eaf 100644
--- a/drivers/dma/pch_dma.c
+++ b/drivers/dma/pch_dma.c
@@ -961,7 +961,7 @@ static void __devexit pch_dma_remove(struct pci_dev *pdev)
 #define PCI_DEVICE_ID_ML7223_DMA3_4CH	0x8017
 #define PCI_DEVICE_ID_ML7223_DMA4_4CH	0x803B
 
-static const struct pci_device_id pch_dma_id_table[] = {
+DEFINE_PCI_DEVICE_TABLE(pch_dma_id_table) = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_8CH), 8 },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_4CH), 4 },
 	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA1_8CH), 8}, /* UART Video */
-- 
1.7.4


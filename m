Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab1GHIy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:54:28 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40022 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab1GHIyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:54:22 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 08/12] gma500; clean mid files
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:44:52 +0100
Message-ID: <20110708084445.19581.15896.stgit@localhost.localdomain>
In-Reply-To: <20110708084053.19581.81711.stgit@localhost.localdomain>
References: <20110708084053.19581.81711.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mid_bios.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/gma500/mid_bios.c b/drivers/staging/gma500/mid_bios.c
index 9a7731c..8cfe301 100644
--- a/drivers/staging/gma500/mid_bios.c
+++ b/drivers/staging/gma500/mid_bios.c
@@ -237,19 +237,17 @@ static void mid_get_vbt_data(struct drm_psb_private *dev_priv)
 		dev_err(dev->dev, "Unknown revision of GCT!\n");
 		vbt->size = 0;
 	}
-	if (IS_MFLD(dev_priv->dev)){
+	if (IS_MFLD(dev_priv->dev)) {
 		if (panel_id == GCT_DETECT) {
 			if (dev_priv->gct_data.bpi == 2) {
 				dev_info(dev->dev, "[GFX] PYR Panel Detected\n");
 				dev_priv->panel_id = PYR_CMD;
 				panel_id = PYR_CMD;
-			}
-			else if(dev_priv->gct_data.bpi == 0) {
+			} else if (dev_priv->gct_data.bpi == 0) {
 				dev_info(dev->dev, "[GFX] TMD Panel Detected.\n");
 				dev_priv->panel_id = TMD_VID;
 				panel_id = TMD_VID;
-			}
-			else {
+			} else {
 				dev_info(dev->dev, "[GFX] Default Panel (TPO)\n");
 				dev_priv->panel_id = TPO_CMD;
 				panel_id = TPO_CMD;
@@ -268,4 +266,4 @@ int mid_chip_setup(struct drm_device *dev)
 	mid_get_vbt_data(dev_priv);
 	mid_get_pci_revID(dev_priv);
 	return 0;
-}
\ No newline at end of file
+}


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab2FDFmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:42:31 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56777 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab2FDFke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:40:34 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 10/15] gma500: don't register the ACPI video bus
Date: Mon,  4 Jun 2012 01:40:01 -0400
Message-Id: <155689defc782b486a7e6776a57ecc4ebb37ed52.1338786832.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.rc0.100.g5498c5f
In-Reply-To: <1338788406-29981-1-git-send-email-lenb@kernel.org>
References: <1338788406-29981-1-git-send-email-lenb@kernel.org>
In-Reply-To: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
References: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We are not yet ready for this and it makes a mess on some devices.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/gpu/drm/gma500/psb_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/psb_drv.c b/drivers/gpu/drm/gma500/psb_drv.c
index c34adf9..09af2ff 100644
--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -349,7 +349,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	PSB_WSGX32(0x30000000, PSB_CR_BIF_3D_REQ_BASE);
 
 /*	igd_opregion_init(&dev_priv->opregion_dev); */
-	acpi_video_register();
+/*	acpi_video_register(); */
 	if (dev_priv->lid_state)
 		psb_lid_timer_init(dev_priv);
 
-- 
1.7.11.rc0.100.g5498c5f


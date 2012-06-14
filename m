Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab2FOAAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:00:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45919 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab2FOAAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:41 -0400
Message-Id: <20120614235626.993303087@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [ 35/42] gma500: dont register the ACPI video bus
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 155689defc782b486a7e6776a57ecc4ebb37ed52 upstream.

We are not yet ready for this and it makes a mess on some devices.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/gma500/psb_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -349,7 +349,7 @@ static int psb_driver_load(struct drm_de
 	PSB_WSGX32(0x30000000, PSB_CR_BIF_3D_REQ_BASE);
 
 /*	igd_opregion_init(&dev_priv->opregion_dev); */
-	acpi_video_register();
+/*	acpi_video_register(); */
 	if (dev_priv->lid_state)
 		psb_lid_timer_init(dev_priv);
 



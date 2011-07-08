Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1GHIyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:54:09 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40017 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab1GHIyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:54:05 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 07/12] gma500: tidy the mrst files
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:44:34 +0100
Message-ID: <20110708084430.19581.66624.stgit@localhost.localdomain>
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

 drivers/staging/gma500/mrst_device.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gma500/mrst_device.c b/drivers/staging/gma500/mrst_device.c
index 195a25b..436580d 100644
--- a/drivers/staging/gma500/mrst_device.c
+++ b/drivers/staging/gma500/mrst_device.c
@@ -155,7 +155,7 @@ int mrst_backlight_init(struct drm_device *dev)
 
 	mrst_backlight_device = backlight_device_register("mrst-bl",
 					NULL, (void *)dev, &mrst_ops, &props);
-					
+
 	if (IS_ERR(mrst_backlight_device))
 		return PTR_ERR(mrst_backlight_device);
 
@@ -367,7 +367,7 @@ const struct psb_ops mrst_chip_ops = {
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
 	.backlight_init = mrst_backlight_init,
 #endif
-	
+
 	.init_pm = mrst_init_pm,
 	.save_regs = mrst_save_display_registers,
 	.restore_regs = mrst_restore_display_registers,


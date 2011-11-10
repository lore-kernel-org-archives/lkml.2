Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab1KJNjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:39:36 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41603 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1KJNjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:39:35 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] bma023: Add SFI translation for this device
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Nov 2011 13:50:38 +0000
Message-ID: <20111110135036.17701.72980.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Douglas <william.douglas@intel.com>

This needed the sfi IRQ 0xFF fix to go in first. It simply plumbs in the
bma023 driver with the firmware naming of it.

Signed-off-by: William Douglas <william.douglas@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/platform/mrst/mrst.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 144984b..ff2ee7e 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -647,6 +647,7 @@ static void *msic_ocd_platform_data(void *info)
 }
 
 static const struct devs_id __initconst device_ids[] = {
+	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data},
 	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},
 	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data},
 	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},


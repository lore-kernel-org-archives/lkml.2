Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab1FWRXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:23:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932726Ab1FWRXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:23:06 -0400
Date: Thu, 23 Jun 2011 13:23:05 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110623172305.27648.59684.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH 09/35] drivers/gpio changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpio changes for SMBIOS and System Firmware

As part of the new SMBIOS and System Firmware code:

- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/gpio/basic_mmio_gpio.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index 8152e9f..6664e3d 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -59,7 +59,6 @@ o        `                     ~~~~\___/~~~~    ` controller in FPGA is ,.`
 #include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
-#include <linux/mod_devicetable.h>
 #include <linux/basic_mmio_gpio.h>
 
 static void bgpio_write8(void __iomem *reg, unsigned long data)
-- 
1.7.5.4


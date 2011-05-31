Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab1EaPvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:51:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab1EaPvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:51:42 -0400
Date: Tue, 31 May 2011 11:51:41 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110531155140.3507.6599.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/x-c; charset=us-ascii
Subject: [RFC PATCH 09/35] drivers/gpio changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/gpio changes for SMBIOS and System Firmware

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
1.7.5.1


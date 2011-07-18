Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab1GRNQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:16:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab1GRNJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:09:03 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, grant.likely@secretlab.ca
Subject: [PATCH 09/34] drivers/gpio changes for SMBIOS and System Firmware
Date: Mon, 18 Jul 2011 09:08:23 -0400
Message-Id: <1310994528-26276-10-git-send-email-prarit@redhat.com>
In-Reply-To: <1310994528-26276-1-git-send-email-prarit@redhat.com>
References: <1310994528-26276-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the new SMBIOS and System Firmware code:

- cleanup of includes for dmi.h and mod_devicetable.h which were included in
some files that did not need them

Cc: grant.likely@secretlab.ca
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
1.6.5.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab2B2OE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:04:27 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43134 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757837Ab2B2OE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:04:26 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>,
        Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH RFC] spi/omap: Trivial cleanup
Date: Wed, 29 Feb 2012 19:34:06 +0530
Message-ID: <1330524246-8864-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The context is stored directly inside drvdata structure post 
[f887876 spi/omap: Remove bus_num usage for instance index]. 
Remove the OMAP2_MCSPI_MAX_CTRL macro as it is not needed anymore.

Cc: Benoit Cousson <b-cousson@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
Applies on Benoit's for_3.4/dt_spi_eth

 drivers/spi/spi-omap2-mcspi.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index d1eb26c..3526281 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -45,9 +45,6 @@
 
 #define OMAP2_MCSPI_MAX_FREQ		48000000
 
-/* OMAP2 has 3 SPI controllers, while OMAP3 has 4 */
-#define OMAP2_MCSPI_MAX_CTRL 		4
-
 #define OMAP2_MCSPI_REVISION		0x00
 #define OMAP2_MCSPI_SYSSTATUS		0x14
 #define OMAP2_MCSPI_IRQSTATUS		0x18
-- 
1.7.1


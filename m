Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2ITOms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:42:48 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41616 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2ITOmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:42:43 -0400
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [RFC PATCH 13/13] Documentation: add schedule for removing private EDMA API
Date: Thu, 20 Sep 2012 10:43:46 -0400
Message-Id: <1348152226-13588-14-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348152226-13588-1-git-send-email-mporter@ti.com>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The davinci-pcm driver is the last in-kernel user of the private
EDMA API. Once it has been converted to DMA Engine API the
private EDMA API functionality can be folded into the EDMA DMA
Engine driver and removed.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index f4d8c71..64109e6 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -637,3 +637,13 @@ Who:	Russell King <linux@arm.linux.org.uk>,
 	Santosh Shilimkar <santosh.shilimkar@ti.com>
 
 ----------------------------
+
+What:	EDMA private DMA implementation
+When:	2013
+Why:	We have a DMA engine implementation; all users should be updated
+	to use this rather than persisting with the old APIs.  The old APIs
+	block merging the old DMA engine implementation into the DMA
+	engine driver.
+Who:	Matt Porter <mporter@ti.com>
+
+----------------------------
-- 
1.7.9.5


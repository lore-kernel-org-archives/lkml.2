Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2FKJMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:12:21 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38639 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab2FKJMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:12:19 -0400
Date: Mon, 11 Jun 2012 11:11:59 +0200
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [PATCH 1/2 RESEND] staging: usb: gadget: Configurable Composite Gadget
 depends on BLOCK
In-reply-to: <Pine.LNX.4.44L0.1206071646360.1185-100000@iolanthe.rowland.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mnazarewicz@gmail.com>,
        Benoit Goby <benoit@android.com>, Mike Lockwood <lockwood@android.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
Message-id: <1339405919-5845-1-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
Content-transfer-encoding: 7BIT
References: <Pine.LNX.4.44L0.1206071646360.1185-100000@iolanthe.rowland.org>
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/staging/ccg/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ccg/Kconfig b/drivers/staging/ccg/Kconfig
index ff05e52..1f00d70 100644
--- a/drivers/staging/ccg/Kconfig
+++ b/drivers/staging/ccg/Kconfig
@@ -2,7 +2,7 @@ if USB_GADGET
 
 config USB_G_CCG
 	tristate "Configurable Composite Gadget (STAGING)"
-	depends on STAGING && !USB_ZERO && !USB_ZERO_HNPTEST && !USB_AUDIO && !GADGET_UAC1 && !USB_ETH && !USB_ETH_RNDIS && !USB_ETH_EEM && !USB_G_NCM && !USB_GADGETFS && !USB_FUNCTIONFS && !USB_FUNCTIONFS_ETH && !USB_FUNCTIONFS_RNDIS && !USB_FUNCTIONFS_GENERIC && !USB_FILE_STORAGE && !USB_FILE_STORAGE_TEST && !USB_MASS_STORAGE && !USB_G_SERIAL && !USB_MIDI_GADGET && !USB_G_PRINTER && !USB_CDC_COMPOSITE && !USB_G_NOKIA && !USB_G_ACM_MS && !USB_G_MULTI && !USB_G_MULTI_RNDIS && !USB_G_MULTI_CDC && !USB_G_HID && !USB_G_DBGP && !USB_G_WEBCAM
+	depends on STAGING && BLOCK && !USB_ZERO && !USB_ZERO_HNPTEST && !USB_AUDIO && !GADGET_UAC1 && !USB_ETH && !USB_ETH_RNDIS && !USB_ETH_EEM && !USB_G_NCM && !USB_GADGETFS && !USB_FUNCTIONFS && !USB_FUNCTIONFS_ETH && !USB_FUNCTIONFS_RNDIS && !USB_FUNCTIONFS_GENERIC && !USB_FILE_STORAGE && !USB_FILE_STORAGE_TEST && !USB_MASS_STORAGE && !USB_G_SERIAL && !USB_MIDI_GADGET && !USB_G_PRINTER && !USB_CDC_COMPOSITE && !USB_G_NOKIA && !USB_G_ACM_MS && !USB_G_MULTI && !USB_G_MULTI_RNDIS && !USB_G_MULTI_CDC && !USB_G_HID && !USB_G_DBGP && !USB_G_WEBCAM
 	help
 	  The Configurable Composite Gadget supports multiple USB
 	  functions: acm, mass storage, rndis and FunctionFS.
-- 
1.7.0.4


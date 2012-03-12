Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab2CLV4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:56:06 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:35728 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757575Ab2CLV4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:56:04 -0400
From: Roland Stigge <stigge@antcom.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v8 1/4] USB: OHCI-HCD: Rename ohci-pnx4008 to ohci-nxp
Date: Mon, 12 Mar 2012 22:54:49 +0100
Message-Id: <1331589292-18986-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331589292-18986-1-git-send-email-stigge@antcom.de>
References: <1331589292-18986-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since this driver is compatible with several NXP devices, the driver is renamed
accordingly. Please combine with the following patch which also changes the
respective symbol names.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/usb/host/ohci-hcd.c                     |    2 +-
 drivers/usb/host/{ohci-pnx4008.c => ohci-nxp.c} |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename drivers/usb/host/{ohci-pnx4008.c => ohci-nxp.c} (100%)

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 34b9edd..713c66c 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1051,7 +1051,7 @@ MODULE_LICENSE ("GPL");
 #endif
 
 #ifdef CONFIG_ARCH_PNX4008
-#include "ohci-pnx4008.c"
+#include "ohci-nxp.c"
 #define PLATFORM_DRIVER		usb_hcd_pnx4008_driver
 #endif
 
diff --git a/drivers/usb/host/ohci-pnx4008.c b/drivers/usb/host/ohci-nxp.c
similarity index 100%
rename from drivers/usb/host/ohci-pnx4008.c
rename to drivers/usb/host/ohci-nxp.c
-- 
1.7.9


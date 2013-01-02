Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3ABPCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:02:21 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56855 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab3ABPB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:01:57 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 22/22] mdf: omap-usb-host: get rid of build warning
Date: Wed, 2 Jan 2013 17:00:42 +0200
Message-ID: <1357138842-28964-23-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357138842-28964-1-git-send-email-rogerq@ti.com>
References: <1357138842-28964-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the below build warning when driver is built-in.

drivers/mfd/omap-usb-host.c:750:12: warning:
‘usbhs_omap_remove’ defined but not used [-Wunused-function]

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index bf2a06a..ecdafbd 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -782,7 +782,7 @@ static struct platform_driver usbhs_omap_driver = {
 		.owner		= THIS_MODULE,
 		.pm		= &usbhsomap_dev_pm_ops,
 	},
-	.remove		= __exit_p(usbhs_omap_remove),
+	.remove		= usbhs_omap_remove,
 };
 
 MODULE_AUTHOR("Keshava Munegowda <keshava_mgowda@ti.com>");
-- 
1.7.4.1


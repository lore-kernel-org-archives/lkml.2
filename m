Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2JHNPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:15:06 -0400
Received: from zmc.proxad.net ([212.27.53.206]:33291 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab2JHNOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:14:51 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 29/32 v2] USB: EHCI: fix typo in ehci-platform driver on the word "resource"
Date: Mon,  8 Oct 2012 15:11:43 +0200
Message-Id: <1349701906-16481-30-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349701906-16481-1-git-send-email-florian@openwrt.org>
References: <1349701906-16481-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the obvious typo in the error message, we meant to write "resource"
instead of "recourse".

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes in v2:
- rebased against greg's latest usb-next

 drivers/usb/host/ehci-platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index 6516717..3cb0b1b 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -103,7 +103,7 @@ static int __devinit ehci_platform_probe(struct platform_device *dev)
 	}
 	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res_mem) {
-		dev_err(&dev->dev, "no memory recourse provided");
+		dev_err(&dev->dev, "no memory resource provided");
 		return -ENXIO;
 	}
 
-- 
1.7.9.5


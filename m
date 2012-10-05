Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab2JEQYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:24:48 -0400
Received: from zmc.proxad.net ([212.27.53.206]:56547 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909Ab2JEQXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:23:46 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 30/32] USB: OHCI: fix typo in ohci-platform driver on the word "resource"
Date: Fri,  5 Oct 2012 18:21:02 +0200
Message-Id: <1349454064-11606-31-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349454064-11606-1-git-send-email-florian@openwrt.org>
References: <1349454064-11606-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We meant to write "resource" instead of "recourse", this patch fixes this
typo.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
 drivers/usb/host/ohci-platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
index 8a606f4..1344426 100644
--- a/drivers/usb/host/ohci-platform.c
+++ b/drivers/usb/host/ohci-platform.c
@@ -107,7 +107,7 @@ static int __devinit ohci_platform_probe(struct platform_device *dev)
 
 	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res_mem) {
-		dev_err(&dev->dev, "no memory recourse provided");
+		dev_err(&dev->dev, "no memory resource provided");
 		return -ENXIO;
 	}
 
-- 
1.7.9.5


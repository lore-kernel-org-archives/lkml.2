Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1GLLFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 07:05:37 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33787 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab1GLLFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 07:05:36 -0400
Subject: [PATCH] USB: s3c2410_udc: fix unterminated platform_device_id table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Herbert =?ISO-8859-1?Q?P=F6tzl?= <herbert@13thfloor.at>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 19:05:29 +0800
Message-ID: <1310468729.6590.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/usb/gadget/s3c2410_udc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index 85c1b0d..8d31848 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -2060,6 +2060,7 @@ static int s3c2410_udc_resume(struct platform_device *pdev)
 static const struct platform_device_id s3c_udc_ids[] = {
 	{ "s3c2410-usbgadget", },
 	{ "s3c2440-usbgadget", },
+	{ }
 };
 MODULE_DEVICE_TABLE(platform, s3c_udc_ids);
 
-- 
1.7.4.1




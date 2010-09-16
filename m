Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0IPPhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 11:37:45 -0400
Received: from smtp.minet.uni-jena.de ([141.35.14.220]:36764 "EHLO
	mx1.mirz.uni-jena.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab0IPPho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:37:44 -0400
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2010 11:37:44 EDT
Message-Id: <20100916152840.9CCB024052@mx1.mirz.uni-jena.de>
Date: Thu, 16 Sep 2010 17:28:40 +0200 (CEST)
From: adi@drcomp.erfurt.thur.de
To: undisclosed-recipients:;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8314f5b151dcddea0359137cfd44d6d8b58f8367 Mon Sep 17 00:00:00 2001
From: Adrian Knoth <adi@drcomp.erfurt.thur.de>
Date: Thu, 16 Sep 2010 17:04:24 +0200
Subject: [PATCH] Fix FTBFS caused by RT-patch in drivers/staging/comedi/drivers/usbdux.c
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com,
    tglx@linutronix.de

This patch corrects a typo in the RT patchset that prevents usbdux.c
from being built.

Signed-off-by: Adrian Knoth <adi@drcomp.erfurt.thur.de>
---
 drivers/staging/comedi/drivers/usbdux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index d611bd7..b98e91c 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2370,7 +2370,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	dev_dbg(dev, "comedi_: usbdux: "
 		"usbduxsub[%d] is ready to connect to comedi.\n", index);
 
-	sema_init(&(usbduxsub[index].sem)), 1;
+	sema_init(&(usbduxsub[index].sem), 1);
 	/* save a pointer to the usb device */
 	usbduxsub[index].usbdev = udev;
 
-- 
1.7.1


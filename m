Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab1FERgK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 13:36:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37629 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab1FERgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 13:36:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=r2pnX8rlM5C3Mzlm9b/nUWWyroDOgfbu0mLJ14r5vrnKxEDAIATTDXVQafnj1du9ov
         5UHMdy66kB18btqS3/JNfF41Eb05qrLOehkchuTwhI+bsJEfP6CIO1jxs0e77gppIoyT
         vgN8KynV30XY//glaCKwBqZcgve73+CRRUajc=
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <Mark.Einon@gmail.com>,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 4/5] staging: et131x: et131x_initpci.c checkpatch fixes
Date: Sun,  5 Jun 2011 18:35:19 +0100
Message-Id: <1307295320-31716-5-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
References: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Einon <Mark.Einon@gmail.com>

Fixes 'WARNING: Avoid line continuations in quoted strings' and some formatting
issues.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_initpci.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 50237ac..1dd2e5e 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -113,13 +113,13 @@
 static u32 et131x_speed_set;
 module_param(et131x_speed_set, uint, 0);
 MODULE_PARM_DESC(et131x_speed_set,
-		"Set Link speed and dublex manually (0-5)  [0]\n \
-		 1 : 10Mb   Half-Duplex\n \
-		 2 : 10Mb   Full-Duplex\n \
-		 3 : 100Mb  Half-Duplex\n \
-		 4 : 100Mb  Full-Duplex\n \
-		 5 : 1000Mb Full-Duplex\n \
-		 0 : Auto Speed Auto Dublex");
+		"Set Link speed and dublex manually (0-5)  [0]\n"
+		"1 : 10Mb   Half-Duplex\n"
+		"2 : 10Mb   Full-Duplex\n"
+		"3 : 100Mb  Half-Duplex\n"
+		"4 : 100Mb  Full-Duplex\n"
+		"5 : 1000Mb Full-Duplex\n"
+		"0 : Auto Speed Auto Dublex");
 
 /**
  * et131x_hwaddr_init - set up the MAC Address on the ET1310
@@ -539,7 +539,8 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 
 	struct et131x_adapter *etdev;
 
-	/* Setup the fundamental net_device and private adapter structure elements  */
+	/* Setup the fundamental net_device and private adapter structure
+	 * elements  */
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
 	/* Allocate private adapter struct and copy in relevant information */
@@ -807,12 +808,12 @@ static struct pci_device_id et131x_pci_table[] __devinitdata = {
 MODULE_DEVICE_TABLE(pci, et131x_pci_table);
 
 static struct pci_driver et131x_driver = {
-      .name	= DRIVER_NAME,
-      .id_table	= et131x_pci_table,
-      .probe	= et131x_pci_setup,
-      .remove	= __devexit_p(et131x_pci_remove),
-      .suspend	= NULL,		/* et131x_pci_suspend */
-      .resume	= NULL,		/* et131x_pci_resume */
+	.name		= DRIVER_NAME,
+	.id_table	= et131x_pci_table,
+	.probe		= et131x_pci_setup,
+	.remove		= __devexit_p(et131x_pci_remove),
+	.suspend	= NULL,		/* et131x_pci_suspend */
+	.resume		= NULL,		/* et131x_pci_resume */
 };
 
 
-- 
1.7.4.4


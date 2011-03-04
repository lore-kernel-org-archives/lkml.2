Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab1CDXFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 18:05:09 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:7849 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707Ab1CDXFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 18:05:08 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 18:05:07 EST
Date: Fri, 4 Mar 2011 16:55:07 -0600
From: scameron@beardog.cce.hp.com
To: james.bottomley@hansenpartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        scameron@beardog.cce.hp.com, mike.mikem@beardog.cce.hp.com,
        thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com
Subject: [PATCH] hpsa: fix incorrect PCI IDs and add two new ones
Message-ID: <20110304225507.GA13522@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit d241b7cbd5b05c591aff96c5f1f0b7d616fdc0c3
Author: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Date:   Fri Mar 4 21:45:14 2011 -0600

    hpsa: fix some incorrect PCI IDs and add a couple of new ones.
    
    Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c30591f..89cf5be 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -89,11 +89,13 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324a},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324b},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3233},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3250},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3251},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3350},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3351},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3352},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3353},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3354},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3355},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3356},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -113,11 +115,13 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324a103C, "Smart Array P712m", &SA5_access},
 	{0x324b103C, "Smart Array P711m", &SA5_access},
-	{0x3250103C, "Smart Array", &SA5_access},
-	{0x3250113C, "Smart Array", &SA5_access},
-	{0x3250123C, "Smart Array", &SA5_access},
-	{0x3250133C, "Smart Array", &SA5_access},
-	{0x3250143C, "Smart Array", &SA5_access},
+	{0x3350103C, "Smart Array", &SA5_access},
+	{0x3351103C, "Smart Array", &SA5_access},
+	{0x3352103C, "Smart Array", &SA5_access},
+	{0x3353103C, "Smart Array", &SA5_access},
+	{0x3354103C, "Smart Array", &SA5_access},
+	{0x3355103C, "Smart Array", &SA5_access},
+	{0x3356103C, "Smart Array", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 

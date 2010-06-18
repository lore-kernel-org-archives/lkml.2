Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0FRGaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 02:30:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47146 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab0FRGaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 02:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=FnKI1ED9STUzhRY80T2QWwejsdQ64ko+tsxZd/hnrYxMZJ3/aRmH6qeyh0aOq91VSa
         LoSv1K53X7UbfRiiWqOx6hIxdlzHa3/94VIyQ6egi0fn01/RVU+Zt3VWEz1uaqHE/7em
         WJtlkhJ9X8WzQqZqmkJXsXjAuofFPLxg0fcCU=
MIME-Version: 1.0
Date: Fri, 18 Jun 2010 15:30:02 +0900
Message-ID: <AANLkTimx1HWYzG0qQqP12ObWQI1eiH5SoFpRic06uN3f@mail.gmail.com>
Subject: [PATCH] USB: serial: ftdi: correct merge conflict with CONTEC id
From: Daniel Sangorrin <daniel.sangorrin@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Radek Liboska <liboska@uochb.cas.cz>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects a problem with the merge of a previous
patch to add the CONTEC identifier.

Signed-off-by: Daniel Sangorrin <daniel.sangorrin@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c     |    1 -
 drivers/usb/serial/ftdi_sio_ids.h |    7 -------
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 79dd1ae..da7e334 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -653,7 +653,6 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(EVOLUTION_VID, EVOLUTION_ER1_PID) },
 	{ USB_DEVICE(EVOLUTION_VID, EVO_HYBRID_PID) },
 	{ USB_DEVICE(EVOLUTION_VID, EVO_RCM4_PID) },
-	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ARTEMIS_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ATIK_ATK16_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ATIK_ATK16C_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h
b/drivers/usb/serial/ftdi_sio_ids.h
index 94d86c3..bbc159a 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -501,13 +501,6 @@
 #define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */

 /*
- * Contec products (http://www.contec.com)
- * Submitted by Daniel Sangorrin
- */
-#define CONTEC_VID		0x06CE	/* Vendor ID */
-#define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
-
-/*
  * Definitions for B&B Electronics products.
  */
 #define BANDB_VID		0x0856	/* B&B Electronics Vendor ID */
-- 
1.7.0.4

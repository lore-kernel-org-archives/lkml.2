Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0JNJjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:39:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56186 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab0JNJjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=adHwMz2cKwxglk1hxXJxHQM0G3On+YJAZBef0+etO3yn6cjA+zgTJ9oUd8XOUsyC5V
         1MG8K62uaaXXEQsx7IA6jDPwHIqgpu7I5vlp4Vnz5mMrSVxmOIkuBvWRbETKNx9f9K02
         pqQ1yJbj5OKLw1TNzgYDuRu0+OgCi0rTzXoM4=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 3/5] staging:ft1000: replace and remove c99 comments.
Date: Thu, 14 Oct 2010 11:40:58 +0200
Message-Id: <1287049260-11988-4-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287049260-11988-1-git-send-email-marek.belisko@gmail.com>
References: <1287049260-11988-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comments for probe, disconnect, init and exit functions
removed completely (functions names are self explaining).

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |   67 +++--------------------
 1 files changed, 9 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index fc817cb..c6aec27 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -1,11 +1,12 @@
-//=====================================================
-// CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
-//
-//
-// This file is part of Express Card USB Driver
-//
-// $Id:
-//====================================================
+/*=====================================================
+ * CopyRight (C) 2007 Qualcomm Inc. All Rights Reserved.
+ *
+ *
+ * This file is part of Express Card USB Driver
+ *
+ * $Id:
+ *====================================================
+ */
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -54,20 +55,6 @@ int ft1000_poll_thread(void *arg)
 	return STATUS_SUCCESS;
 }
 
-
-
-//---------------------------------------------------------------------------
-// Function:    ft1000_probe
-//
-// Parameters:  struct usb_interface *interface  - passed by USB core
-//              struct usb_device_id *id         - passed by USB core
-// Returns:     0 - success
-//
-// Description: This function is invoked when the express card is plugged in
-//
-// Notes:
-//
-//---------------------------------------------------------------------------
 static int ft1000_probe(struct usb_interface *interface,
 			const struct usb_device_id *id)
 {
@@ -219,18 +206,6 @@ err_fw:
 	return ret;
 }
 
-//---------------------------------------------------------------------------
-// Function:    ft1000_disconnect
-//
-// Parameters:  struct usb_interface *interface  - passed by USB core
-//
-// Returns:     0 - success
-//
-// Description: This function is invoked when the express card is plugged out
-//
-// Notes:
-//
-//---------------------------------------------------------------------------
 static void ft1000_disconnect(struct usb_interface *interface)
 {
     FT1000_INFO *pft1000info;
@@ -277,18 +252,6 @@ static struct usb_driver ft1000_usb_driver = {
     .id_table = id_table,
 };
 
-//---------------------------------------------------------------------------
-// Function:    usb_ft1000_init
-//
-// Parameters:  none
-//
-// Returns:     0 - success
-//
-// Description: The entry point of the module, register the usb driver
-//
-// Notes:
-//
-//---------------------------------------------------------------------------
 static int __init usb_ft1000_init(void)
 {
     int ret = 0;
@@ -302,18 +265,6 @@ static int __init usb_ft1000_init(void)
     return ret;
 }
 
-//---------------------------------------------------------------------------
-// Function:    usb_ft1000_exit
-//
-// Parameters:
-//
-// Returns:
-//
-// Description: Moudle unload function, deregister usb driver
-//
-// Notes:
-//
-//---------------------------------------------------------------------------
 static void __exit usb_ft1000_exit(void)
 {
     DEBUG("Deregister the driver\n");
-- 
1.7.1


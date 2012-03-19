Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031820Ab2CSPGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:06:42 -0400
Received: from s192156.ppp.asahi-net.or.jp ([220.157.192.156]:4875 "EHLO
	suika.yumene.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030654Ab2CSPGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:06:41 -0400
X-Greylist: delayed 889 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2012 11:06:41 EDT
Authentication-Results: suika.yumene.net; sender-id=permerror header.from=nico@meiwaku.net; spf=permerror smtp.mfrom=nico@meiwaku.net
Date: Mon, 19 Mar 2012 23:49:49 +0900
From: nico <nico@meiwaku.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] New product ID for pl2303.ko (USB serial device)
Message-Id: <20120319234949.77ab0a4c.nico@meiwaku.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Please add a new product ID to drivers/usb/serial/pl2303.h and pl2303.c.
It works fine on Linux 2.6.32 (Ubuntu 10.04.4 LTS).


--- pl2303.c.org	2012-02-14 06:46:49.000000000 +0900
+++ pl2303.c	2012-03-17 14:22:18.844699349 +0900
@@ -63,6 +63,7 @@
 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID_MOTOROLA) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID) },
 	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID_RSAQ5) },
+	{ USB_DEVICE(IODATA_VENDOR_ID, IODATA_PRODUCT_ID_WSIM) },
 	{ USB_DEVICE(ATEN_VENDOR_ID, ATEN_PRODUCT_ID) },
 	{ USB_DEVICE(ATEN_VENDOR_ID2, ATEN_PRODUCT_ID) },
 	{ USB_DEVICE(ELCOM_VENDOR_ID, ELCOM_PRODUCT_ID) },


--- pl2303.h.org	2012-02-14 06:46:49.000000000 +0900
+++ pl2303.h	2012-03-17 14:23:30.044700076 +0900
@@ -30,6 +30,7 @@
 #define IODATA_VENDOR_ID	0x04bb
 #define IODATA_PRODUCT_ID	0x0a03
 #define IODATA_PRODUCT_ID_RSAQ5	0x0a0e
+#define IODATA_PRODUCT_ID_WSIM	0x0940
 
 #define ELCOM_VENDOR_ID		0x056e
 #define ELCOM_PRODUCT_ID	0x5003

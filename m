Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab1CLJho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 04:37:44 -0500
Received: from bounce-out.neti.ee ([194.126.101.104]:45027 "EHLO
	bounce-out.neti.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab1CLJhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 04:37:42 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Mar 2011 04:37:42 EST
X-SMTP-Auth-NETI-Businessmail: no
Subject: [PATCH] zd1211rw: TrendNet TEW-509UB id added
From: =?ISO-8859-1?Q?T=F5nu?= Samuel <tonu@jes.ee>
To: linux-kernel@vger.kernel.org
Cc: tonu@jes.ee
Content-Type: multipart/mixed; boundary="=-dkPSyqgEWDobYrv1ZwZh"
Date: Sat, 12 Mar 2011 11:29:25 +0200
Message-ID: <1299922165.3044.1.camel@hp>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dkPSyqgEWDobYrv1ZwZh
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



--=-dkPSyqgEWDobYrv1ZwZh
Content-Disposition: attachment; filename="Trendnet-TEW-509UB.patch"
Content-Type: text/x-patch; name="Trendnet-TEW-509UB.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

--- ./drivers/net/wireless/zd1211rw/zd_usb.c	2011-03-08 01:05:50.000000000 +0200
+++ /usr/src/linux-2.6.37.3/drivers/net/wireless/zd1211rw/zd_usb.c	2011-03-12 10:21:48.261473001 +0200
@@ -59,6 +59,7 @@
 	{ USB_DEVICE(0x157e, 0x300a), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x157e, 0x300b), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x157e, 0x3204), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x157e, 0x3207), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x1740, 0x2000), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */

--=-dkPSyqgEWDobYrv1ZwZh--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab2ERSLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:11:23 -0400
Received: from nm19.bullet.mail.sp2.yahoo.com ([98.139.91.89]:33522 "HELO
	nm19.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757978Ab2ERSLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:11:21 -0400
X-Yahoo-Newman-Id: 649946.31294.bm@smtp207.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: cqJwVHQVM1l1fpQaX.XnzHT7QvmJUJ65906pEh0hujnsjkH
 4QenOJ8czV1G48AIrvUvID_HmRCbqHCwB8DI_OuuunnL1NfHc_XvOpY2dcJA
 qL6CKzEfbcI7IFSjpx9rC0lEX5QaJtI75rBNNhdsXL8CpHr6GLlUPq1k3AiF
 np6C.hqdNuit9VN66tAz5WJLlMPMQajdkA1VeKpIBmULw_dpCf1GghjMst7A
 i7Gf4e1.wdpDC0FbS.BVqb73FvH1o.IHLKIELAKRo9bY.jItQfRKs_NBS0I9
 8083IDQENeP9aB4pX0mATx2YQ4iWmvH_5zZOfO69s2eSSIY5MgIJCnHx8twR
 pLm7Qt5XYt9CP_BjR7YAVCYGQHEU3sABZezo4bn86UNUsthC7475RbeXIRJa
 e623w5X0EVJTkpdEb0.gL9lcMuyJjNSJJrSHKRM9vWw0IEIPxJZ6DIt2LWef
 XzHBKYrx763cayoalpaRluYNmd5oFJs6D4FYz2IxN6qkiDcClPbm4yqTLgH0
 -
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: mdharm-usb@one-eyed-alien.net, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH 452/452]USB :storage:fixed space at the start of a line issues.
Date: Fri, 18 May 2012 23:44:35 +0530
Message-Id: <1337364875-3494-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed space at the start of a line issues found
by checkpatch.pl tool in drivers/usb/storage/usual-tables.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 drivers/usb/storage/usual-tables.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual-tables.c
index b969279..f2301ee 100644
--- a/drivers/usb/storage/usual-tables.c
+++ b/drivers/usb/storage/usual-tables.c
@@ -34,17 +34,17 @@
 		    vendorName, productName, useProtocol, useTransport, \
 		    initFunction, flags) \
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
-  .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
+.driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
 #define COMPLIANT_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
 		    vendorName, productName, useProtocol, useTransport, \
 		    initFunction, flags) \
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
-  .driver_info = (flags) }
+.driver_info = (flags) }
 
 #define USUAL_DEV(useProto, useTrans, useType) \
 { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans), \
-  .driver_info = ((useType)<<24) }
+.driver_info = ((useType)<<24) }
 
 struct usb_device_id usb_storage_usb_ids[] = {
 #	include "unusual_devs.h"
-- 
1.7.10


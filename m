Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966733Ab2ERTPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 15:15:33 -0400
Received: from nm13.bullet.mail.bf1.yahoo.com ([98.139.212.172]:24501 "HELO
	nm13.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759350Ab2ERTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 15:15:30 -0400
X-Yahoo-Newman-Id: 370967.59474.bm@smtp112.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: biiFoQgVM1lhjb84EdwQ8jNtzBO2WriXlQ1XvQxerguDljx
 AFnjcQNCM0C3yG0YfspJ1iNekPlqTXNUTXFerRa4OuCi_5WXiuEhK.cilg62
 Rt.2ZNigvY2cHTv4gMF175ZpVbkTdc9IFql.uraxkOIOs43pUCsLq_6vm3Rz
 gRm0pwr9YPsO6ZvaQzYG2lQGN_RhBhTm7Tpa6dYy6.rC6ge408KS_mw3LHe.
 gH6oDSgO0kslPlBgj1XbWCoqjh6u59vzyz_nwM2EK9YdI53NALYL5TQ94ZBF
 l1Hd.cZwQgqObpq_VewBjsKyqOwUMxrWjLBdvHCXH7J.4qgG1dp046znCVM8
 ES.LhVPVV5ELdOBBCuHzP45UnBCjjzgvGm0yCKL8JLp62eqBU2xNTLyqzuKg
 O4s53X_d6HHnIRt4MqJ6X3gj8UUNSJesGYtU2DNXMZG.1aTUaFzZ_KDVtr.r
 DJqxWRXUs1s3Sd.wOCauJEQbXCvzZA5N9LxcJumo6pZHjNy9FKgoOg5.xnvw
 CqP.5kOqR
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: mdharm-usb@one-eyed-alien.net, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH 1/1]USB:storage:fixed space at the start of a line issues.
Date: Sat, 19 May 2012 00:48:35 +0530
Message-Id: <1337368715-3859-1-git-send-email-ahiliation@yahoo.co.in>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab0HGGgJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:36:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47470 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235Ab0HGGgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:36:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=TMz18QvShDXq/fb2NBkWkj5TpdFHwCUi6XjB3BryhHI9ZTuE7ksHJW+smGnGXecs1l
         /OSwPqLaV/vtyMLUF0SPMyvcjjEakwv8/91G7cO5A14bIQXqcunVX0IriNsgZl5DL+rq
         gWedihr99vr8ep5BLqildMBnaA92ID1ABP4y0=
Subject: [PATCH 05/14] staging: comedi (me4000): use PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:35:57 -0400
Message-ID: <1281162957.7976.12.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_DEVICE() macro for pci table entries on comedi driver and thus improves readability.


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/me4000.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 1471384..e6825c2 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -71,21 +71,20 @@ broken.
   ===========================================================================*/
 
 static DEFINE_PCI_DEVICE_TABLE(me4000_pci_table) = {
-	{
-	PCI_VENDOR_ID_MEILHAUS, 0x4650, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_MEILHAUS, 0x4660, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_MEILHAUS, 0x4661, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_MEILHAUS, 0x4662, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_MEILHAUS, 0x4663, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_MEILHAUS, 0x4670, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_MEILHAUS, 0x4671, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_MEILHAUS, 0x4672, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_MEILHAUS, 0x4673, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_MEILHAUS, 0x4680, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_MEILHAUS, 0x4681, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_MEILHAUS, 0x4682, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_MEILHAUS, 0x4683, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4650) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4660) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4661) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4662) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4663) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4670) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4671) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4672) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4673) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4680) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4681) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4682) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEILHAUS, 0x4683) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, me4000_pci_table);
-- 
1.7.0.4




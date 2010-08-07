Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446Ab0HGGht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:37:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64150 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698Ab0HGGhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=NcJJvSxztxvPCxaAIowVJI5VLZMD2gg1LmlJQaR3xR+Lw6L1uXoNEEIbRWJxZtxd6u
         FG0tMXPlSWMoinKMm3eOeSOIBTSmBULZDydKPPJOHGadN4pOW1X1AF4mQMRq88QnGspz
         i0rdSxgsiyKuz+pCPxjPaFQ7FWG6caO/DwPcg=
Subject: [PATCH 07/14] staging: comedi (adv_pci_dio): use PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:37:42 -0400
Message-ID: <1281163062.7976.14.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_DEVICE() macro for pci table entries on comedi driver and thus improves readability.


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci_dio.c |   29 ++++++++++++-------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index d018bb4..9102667 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -256,21 +256,20 @@ struct dio_boardtype {
 };
 
 static DEFINE_PCI_DEVICE_TABLE(pci_dio_pci_table) = {
-	{
-	PCI_VENDOR_ID_ADVANTECH, 0x1730, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1733, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1734, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1735, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1736, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1750, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1751, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1752, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1753, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1754, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1756, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1760, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1762, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1730) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1733) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1734) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1735) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1736) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1750) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1751) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1752) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1753) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1754) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1756) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1760) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1762) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, pci_dio_pci_table);
-- 
1.7.0.4




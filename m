Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870Ab0HGGnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:43:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46537 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761244Ab0HGGnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:43:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=uEM02k0DfNNXAT3waP4Ea2Vj+wK/R53T3RkD9hBoXy5k//uxRXz3sxbwvKw14TuWmG
         63Gn7cLfucbTzryGdL2ZsrCVMBtuttJaQBsSvI/IstE18RhmVy6agnTlrK1caKa3Y9aD
         dQ0FgM0hJwTo21/JteTHvi8pgWNC4wcV1xiGU=
Subject: [PATCH 14/14] staging: comedi (dt3000): use PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:43:44 -0400
Message-ID: <1281163424.7976.21.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_DEVICE() macro for pci table entries on comedi driver and thus improves readability.


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/dt3000.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 656e7bb..6170f7b 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -165,15 +165,14 @@ static const struct dt3k_boardtype dt3k_boardtypes[] = {
 #define this_board ((const struct dt3k_boardtype *)dev->board_ptr)
 
 static DEFINE_PCI_DEVICE_TABLE(dt3k_pci_table) = {
-	{
-	PCI_VENDOR_ID_DT, 0x0022, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_DT, 0x0027, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_DT, 0x0023, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_DT, 0x0024, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_DT, 0x0028, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_DT, 0x0025, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_DT, 0x0026, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0022) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0027) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0023) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0024) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0028) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0025) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DT, 0x0026) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, dt3k_pci_table);
-- 
1.7.0.4




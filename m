Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab0HGGcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:32:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57149 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab0HGGcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:32:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=m2pFySybrameeS4gy00QdXePlUthM1sBpA2PLYXBV8M1o//WY/rOnY86Gvl/u9MTbs
         Td9ue5dTjy+DPkvHI0SfYSj0pmBu2EYfUbKxEhzNFoEP5oPAkLL1ovPACsDUe/Z6ATNW
         yNEe2MWGmmj4mURwJ7mgMmFb9Oc2Kfpe5l3ZM=
Subject: [PATCH 02/14] staging: comedi (cb_pcidda): use PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:32:43 -0400
Message-ID: <1281162763.7976.8.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_DEVICE() macro for pci table entries on comedi driver and thus improves readability.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidda.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 2d35143..6383fc9 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -196,14 +196,13 @@ static const struct cb_pcidda_board cb_pcidda_boards[] = {
 };
 
 static DEFINE_PCI_DEVICE_TABLE(cb_pcidda_pci_table) = {
-	{
-	PCI_VENDOR_ID_CB, 0x0020, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x0021, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x0022, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x0023, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x0024, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_CB, 0x0025, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0020) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0021) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0022) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0023) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0024) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CB, 0x0025) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, cb_pcidda_pci_table);
-- 
1.7.0.4




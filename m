Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573Ab0HGGl1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:41:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37864 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab0HGGlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:41:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=ZZJUvDWDroiGEVqsAYtwKVnbIMzSIUF6OrIe4zNbWjBPlZdzoMirVgxIh5vEchWZPN
         bPbxjatM2aetppCY+e5e+RkwiWXYVjaJ3Dar9aYcxFN5KbQmT8EVbnW38ogNJwMDTxPF
         OGhXrBfWgTJM/BmnfqXcDOLUue8s4WSoDqmuQ=
Subject: [PATCH 11/14] staging: comedi (adv_pci1710): use PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:41:17 -0400
Message-ID: <1281163277.7976.18.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_DEVICE() macro for pci table entries on comedi driver and thus improves readability.


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index bdd6954..466e69f 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -217,13 +217,12 @@ struct boardtype {
 };
 
 static DEFINE_PCI_DEVICE_TABLE(pci1710_pci_table) = {
-	{
-	PCI_VENDOR_ID_ADVANTECH, 0x1710, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1711, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1713, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1720, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	PCI_VENDOR_ID_ADVANTECH, 0x1731, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1710) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1711) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1713) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1720) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1731) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, pci1710_pci_table);
-- 
1.7.0.4




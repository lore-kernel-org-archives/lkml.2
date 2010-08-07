Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761710Ab0HGGmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:42:18 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44779 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760649Ab0HGGmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:42:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=VF2AYCUwwAXgfc8KlOudam9BgGdYmCq8NVaXubJCuoFUG1E/GjZq/8nTL8/V4o8mD0
         PV1bWSesFtxCKYC6k0+A70JPwLkp3CUstGzDMKYq8v6+wAmRG3iiSGivrBfyqjXGkOv1
         yLbOcEkhnIibncZX2lHmh9FB4IA7rALstFqpg=
Subject: [PATCH 12/14] staging: comedi (adv_pci1723): use PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:42:07 -0400
Message-ID: <1281163327.7976.19.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_DEVICE() macro for pci table entries on comedi driver and thus improves readability.


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1723.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index b133bb8..1b56821 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -155,9 +155,8 @@ static const struct pci1723_board boardtypes[] = {
  * Should only be used for PCI and ISA-PnP devices
  */
 static DEFINE_PCI_DEVICE_TABLE(pci1723_pci_table) = {
-	{
-	PCI_VENDOR_ID_ADVANTECH, 0x1723, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADVANTECH, 0x1723) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, pci1723_pci_table);
-- 
1.7.0.4




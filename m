Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862Ab0HGGis (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 02:38:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51200 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969Ab0HGGin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 02:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=R9u0eUpLGE4MsbB9RiJevcwub/sjmqS5LHlKv9CKDp7yYsACLF9G7vEIF2SPxdw5tv
         FNK4aaDoXgdQgWD7li149NQYvHWJH2NLRjD9Iwu/Dv3r1tffftIYv0yP+Nlv997PQpzt
         Jksi8/QkVzz9tydbREwuqiX8a9PH0YQOeQ/WE=
Subject: [PATCH 08/14] staging: comedi (adl_pci6208): use PCI_DEVICE() macro
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Arun Thomas <arun.thomas@gmail.com>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 02:38:37 -0400
Message-ID: <1281163117.7976.15.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_DEVICE() macro for pci table entries on comedi driver and thus improves readability.


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci6208.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index 073d024..4fc9e85 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -90,9 +90,8 @@ static const struct pci6208_board pci6208_boards[] = {
 static DEFINE_PCI_DEVICE_TABLE(pci6208_pci_table) = {
 	/* { PCI_VENDOR_ID_ADLINK, 0x6208, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
 	/* { PCI_VENDOR_ID_ADLINK, 0x6208, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 }, */
-	{
-	PCI_VENDOR_ID_ADLINK, 0x6208, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
-	0}
+	{ PCI_DEVICE(PCI_VENDOR_ID_ADLINK, 0x6208) },
+	{ 0 }
 };
 
 MODULE_DEVICE_TABLE(pci, pci6208_pci_table);
-- 
1.7.0.4



